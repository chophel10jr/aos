# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorize_admin
  before_action :set_user, only: [:edit, :update, :destroy]

  def new
  end

  def index
    @users = User.all
  end

  def create
    user = User.new(user_params)
    
    if user.save
      flash[:notice] = "User was successfully created."
    else
      flash[:alert] = "User creation failed: #{user.errors.full_messages.join(', ')}"
    end
  
    redirect_to users_path
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "User was successfully updated."
    else
      flash[:alert] = "User updation failed: #{user.errors.full_messages.join(', ')}"
    end

    redirect_to users_path
  end

  def destroy
    if current_user == @user
      flash[:notice] = "You cannot delete your own account."
    elsif @user.destroy
      flash[:notice] = "User was successfully deleted."
    else
      flash[:alert] = "User deletion failed: #{user.errors.full_messages.join(', ')}"
    end

    redirect_to users_path
  end

  private

  def authorize_admin
    unless current_user&.admin?
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to accounts_path
    end
  end

  def get_role_id(role_name)
    Role.find_by(name: role_name.downcase)&.id
  end

  def user_params
    user_params = params.permit(:user_name, :email, :branch)
    user_params[:password] = params[:password] if params[:password].present?
    user_params[:role_id] = get_role_id(params[:role])

    user_params
  end

  def set_user
    @user = User.find(params[:id])
  end
end
