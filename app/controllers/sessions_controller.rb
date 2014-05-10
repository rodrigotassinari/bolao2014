class SessionsController < ApplicationController

  skip_before_action :require_login, only: [:new, :one_time_token, :create]

  # GET /login
  # Via: login_path
  def new
    @user = User.new(email: params[:email])
  end

  # POST /one_time_token
  # Via: one_time_token_path
  # TODO move to new controller
  def one_time_token
    @user = OneTimeLogin.find_user(params[:email])
    one_time_login = OneTimeLogin.new(@user)
    if @user.valid? && one_time_login.send_authentication_check!
      @remember_me = true
      render :one_time_token
    else
      render :new
    end
  end

  # POST /login
  # Via: login_path
  def create
    email = params[:email]
    password = params[:password]
    remember_me = (params[:remember_me] == 'true')

    @user = OneTimeLogin.find_user(email)

    if @user.valid? && @user.validate_authentication_token!(password)
      create_session(@user, remember_me)
      flash[:success] = t('.flash.authentication_success')
      redirect_to root_path
    else
      destroy_session
      flash[:error] = t('.flash.authentication_failed')
      redirect_to login_path
    end
  end

  # GET /logout
  # Via: logout_path
  def destroy
    destroy_session
    flash[:notice] = t('.flash.logged_out')
    redirect_to root_path
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
