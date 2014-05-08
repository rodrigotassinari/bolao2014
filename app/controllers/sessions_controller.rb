class SessionsController < ApplicationController

  skip_before_action :require_login, only: [:new, :one_time_token, :create]

  # GET /login
  # Via: login_path
  def new
  end

  # POST /one_time_token
  # Via: one_time_token_path
  # TODO move to new controller
  def one_time_token
    @email = params[:email]
    @user = OneTimeLogin.find_user(@email)
    @one_time_login = OneTimeLogin.new(@user)
    if @user.valid? && @one_time_login.send_authentication_check!
      render :one_time_token
    else
      flash[:error] = @user.errors.full_messages.join(',')
      redirect_to login_path
    end
  end

  # POST /login
  # Via: login_path
  def create
    # TODO
    # create_session(user, remember_me=true)
  end

  # GET /logout
  # Via: logout_path
  def destroy
    # TODO
    # destroy_session
  end

  private

  def create_session(user, remember_me=true)
    if remember_me
      cookies.permanent.signed[:remember_me_token] = user.remember_me_token
    else
      cookies.signed[:remember_me_token] = user.remember_me_token
    end
  end

  def destroy_session
    cookies.delete(:remember_me_token)
    reset_session
  end

end
