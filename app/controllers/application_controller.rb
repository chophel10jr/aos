# frozen_string_literal: true

class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def authenticate_user
    redirect_to login_path, alert: "Please log in" unless current_user
  end
end