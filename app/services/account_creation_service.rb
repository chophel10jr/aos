# frozen_string_literal: true

class AccountCreationService
  attr_reader :params, :account, :errors

  def initialize(params, ndi_user)
    @ndi_user = ndi_user
    @params = params
    @errors = []
  end

  def run
    ActiveRecord::Base.transaction do
      create_account
      create_identity
      create_nominees
      create_contact_detail
      create_personal_detail
      create_permanent_address
      create_current_address
      create_spouse_detail
      create_employment_detail
      create_income
      create_account_document
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    @errors << e.message
    false
  end

  private

  def create_account
    account_params = params.require(:account).permit(:branch_code, :account_type, :currency, :mode_of_operation)
    account_params[:status] = 'inprogress'
    account_params[:thread_id] = @ndi_user['threaded_id']

    @account = Account.create!(account_params)
  end

  def create_identity
    account.identity_details.create!(
      id_type: 'cid',
      id_number: @ndi_user['foundational_id']['id_number'],
      id_issued_on: personal_detail_params['cid_issued_on'],
      id_expires_on: personal_detail_params['cid_expires_on']
    )
  end

  def create_nominees
    params['[nominee]'].each do |nominee_params|
      account.nominees.create!(
        nominee_params[1].permit(:name, :date_of_birth, :relationship, :cid_number, :contact_number, :share_percentage)
      )
    end
  end

  def create_contact_detail
    account.create_contact_detail!(
      email_id: @ndi_user['email']['email'],
      contact_number: @ndi_user['mobile_number']['mobile_number']
    )
  end

  def create_personal_detail
    name_parts = NameParserService.new(@ndi_user['foundational_id']['full_name']).run
    personal_detail = account.create_personal_detail!(
      salutation: SalutationService.new(@ndi_user['foundational_id']['gender']).run,
      gender: @ndi_user['foundational_id']['gender'],
      first_name: name_parts[:first_name],
      middle_name: name_parts[:middle_name],
      last_name: name_parts[:last_name],
      date_of_birth: @ndi_user['foundational_id']['date_of_birth'],
      nationality: "Bhutanese",
      education_level: personal_detail_params['education_level'],
      marital_status: spouse_detail_params['marital_status'],
      employment_status: employment_detail_params['employment_status'],
      tax_payer_no: personal_detail_params['tax_payer_no']
    )
  end

  def create_permanent_address
    account.addresses.create!(
      address_type: 'permanent',
      country: "Bhutan",
      district: @ndi_user['permanent_address']['dzongkhag'],
      sub_district: @ndi_user['permanent_address']['gewog'],
      village: @ndi_user['permanent_address']['village'],
      land_record_number: @ndi_user['permanent_address']['thram_number'],
      house_number: @ndi_user['permanent_address']['house_number']
    )
  end

  def create_current_address
    account.addresses.create!(
      address_type: 'current',
      country: @ndi_user['current_address']['country'],
      district: @ndi_user['current_address']['state'],
      sub_district: @ndi_user['current_address']['city'],
      village: @ndi_user['current_address']['suburb'] || @ndi_user['current_address']['street']
    )
  end

  def create_spouse_detail
    return unless account.personal_detail&.marital_status == 'married'

    account.personal_detail&.create_spouse_detail!(
      name: spouse_detail_params['name'],
      cid_number: spouse_detail_params['cid_number'],
      contact_number: spouse_detail_params['contact_number'],
      education_level: spouse_detail_params['education_level'],
      employment_status: spouse_detail_params['employment_status'],
      account_number: spouse_detail_params['account_number']
    )
  end

  def create_employment_detail
    binding.pry
    return unless account.personal_detail&.employment_status != 'unemployed'

    account.personal_detail&.create_employment_detail!(
      employment_type: employment_detail_params['employment_type'],
      employee_type: employment_detail_params['employee_type'],
      employee_id: employment_detail_params['employee_id'],
      organization_name: employment_detail_params['organization_name'],
      organization_address: employment_detail_params['organization_address'],
      designation: employment_detail_params['designation']
    )
  end

  def create_income
    account.create_income_detail!(
      params.require(:income).permit(:source_of_income, :gross_annual_income)
    )
  end

  def create_account_document
    ['signature', 'cid_copy'].each do |document_type|
      base64 = EncodeBase64Service.new(uploaded_file: attachment_params[document_type]).run
      account.account_documents.create!(
        document_type: document_type,
        base64_data: base64
      )
    end
    account.account_documents.create!(
      document_type: 'passport_photo',
      base64_data: @ndi_user['passport_size_photo']['passport_size_photo']
    )
  end

  def personal_detail_params
    params.require(:personal_detail).permit(:cid_issued_on, :cid_expires_on, :tax_payer_no, :fixed_line_no, :education_level)
  end
  
  def attachment_params
    params.require(:personal_detail).permit(:signature, :cid_copy)
  end

  def employment_detail_params
    params.require(:employment_detail).permit(:employment_status, :employee_id, :organization_name, :organization_address, :designation, :employee_type, :employment_type)
  end

  def spouse_detail_params
    params.require(:spouse_detail).permit(:marital_status, :name, :cid_number, :contact_number, :education_level, :employment_status, :has_bnb_account, :account_number)
  end
end
