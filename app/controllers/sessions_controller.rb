class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]

  def new
    # Renders the login form
  end

  def create
    user = User.find_by(email: params[:email])

    # Authenticate the user (assuming password is stored in plain text; replace with secure hashing in production)
    if user && user.password == params[:password]
      session[:user_id] = user.id
      redirect_to accounts_path(status: 'all'), notice: 'Logged in successfully'
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: 'Logged out successfully'
  end

  private

  # Redirect to home if already logged in
  def redirect_if_logged_in
    if session[:user_id]
      redirect_to accounts_path(status: 'all'), alert: 'You are already logged in.'
    end
  end
end
