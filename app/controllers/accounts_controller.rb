# frozen_string_literal: true

require "rqrcode"

class AccountsController < ApplicationController
  before_action :authenticate_user, only: [:index, :update]
  before_action :set_account, only: [:update]
  before_action :fetch_ndi_user, only: [:create, :new, :show_by_token]

  def index
    authorize_user!

    @status = params[:status]
    search_query = params[:search]
    sort_order = sort_order_param

    accounts_scope = base_accounts_scope
    accounts_scope = check_status(accounts_scope)

    if search_query.present?
      accounts_scope = accounts_scope.joins(:identity_details)
                                     .where(identity_details: { id_no: search_query.strip })
    end

    @accounts = accounts_scope.order(sort_order)
  end

  def new
    @token = params[:token]
    return unauthorized_redirect unless @ndi_user

    if account_exists_for_ndi_user?
      flash[:alert] = "You already have an account with BNB."
      return redirect_to root_path
    end

    latest_account = latest_account_for_ndi_user

    if latest_account.present? && latest_account.status != 'rejected'
      handle_latest_account(latest_account)
    end
  end

  def create
    return unauthorized_redirect if @ndi_user.nil? || latest_unrejected_account?

    service = AccountCreationService.new(params, @ndi_user)

    if service.run
      flash[:notice] = "Your application was submitted successfully."
    else
      flash[:alert] = "There was a problem submitting your application."
    end
    redirect_to root_path
  end

  def show_by_token
    return unauthorized_redirect if @ndi_user.nil?

    @account = Account.joins(:identity_details).where(identity_details: { id_number: @ndi_user['foundational_id']['id_number'] }).last || []
  end

  def update
    if @account.update(account_params)
      flash[:notice] = "Account updated successfully."
    else
      flash[:alert] = "Error updating account."
    end
    redirect_to accounts_path(status: 'inprogress')
  end

  def sync_account_with_obo
    result = SyncAccountToOboJob.perform_now(params[:id])

    if result
      flash[:notice] = "Data pushed successfully."
    else
      flash[:alert] = "Failed to push data."
    end

    redirect_to accounts_path(status: 'inprogress')
  end

  private

  def authorize_user!
    return if current_user.admin? || current_user.inputer?

    redirect_to root_path, alert: "Access denied."
  end

  def base_accounts_scope
    if current_user.admin?
      Account.all
    elsif current_user.inputer?
      Account.where(branch_code: current_user.branch)
    end
  end

  def fetch_ndi_user
    token = params[:token]
    return unless token.present?

    decoded_thread_id = DecodeTokenService.new(token: token).run
    return unless decoded_thread_id.present?

    response = FetchVcService.new(token: token).run
    @ndi_user = response.code == "200" ? JSON.parse(response.body) : nil
  end

  def unauthorized_redirect
    flash[:alert] = 'You are not authorized.'
    redirect_to root_path
  end

  def account_exists_for_ndi_user?
    account = CheckAccountExistService.new(cid: @ndi_user["foundational_id"]["id_number"]).run
    account.present? && account['acName'].present?
  end

  def generate_qr_code(response)
    qr_data = response['data']['proofRequestURL']
    qrcode = RQRCode::QRCode.new(qr_data)
    qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 4,
      standalone: true,
      use_path: true,
    )
  end

  def check_status(accounts)
    if params['status'] == 'all'
      accounts.paginate(page: (params[:page].to_i > 0 ? params[:page].to_i : 1), per_page: 10)
    elsif params['status'] == 'inprogress'
      accounts.inprogress.paginate(page: (params[:page].to_i > 0 ? params[:page].to_i : 1), per_page: 10)
    elsif params['status'] == 'approved'
      accounts.approved.paginate(page: (params[:page].to_i > 0 ? params[:page].to_i : 1), per_page: 10)
    elsif params['status'] == 'rejected'
      accounts.rejected.paginate(page: (params[:page].to_i > 0 ? params[:page].to_i : 1), per_page: 10)
    elsif params['status'] == 'already_exists'
      accounts.already_exists.paginate(page: (params[:page].to_i > 0 ? params[:page].to_i : 1), per_page: 10)
    else
      accounts
    end
  end

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:status, :remarks, :account_number)
  end

  def latest_account_for_ndi_user
    return nil unless @ndi_user.present?

    foundation_id_no = @ndi_user["foundational_id"]["id_number"]
    Account.joins(:identity_details)
           .where(identity_details: { id_number: foundation_id_no })
           .order(created_at: :desc)
           .first
  end

  def handle_latest_account(latest_account)
    flash[:alert] = account_status_message(latest_account.status)
    redirect_to root_path
  end

  def account_status_message(status)
    case status
    when 'inprogress'
      'Account is in progress.'
    when 'already_exists'
      'Account already exists.'
    when 'approved'
      'Account is already approved.'
    end
  end

  def latest_unrejected_account?
    latest_account = latest_account_for_ndi_user
    latest_account.present? && latest_account.status != 'rejected'
  end

  def sort_order_param
    case params[:sort]
    when 'oldest'
      { created_at: :asc }
    else
      { created_at: :desc }
    end
  end
end
