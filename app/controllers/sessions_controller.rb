class SessionsController < ApplicationController

  skip_before_action :require_login, only: [:new, :one_time_token, :create]
  before_action :require_guest, except: [:destroy]

  # GET /login
  # Via: login_path
  def new
    @user = User.new(email: sign_in_params[:email])
  end

  # POST /one_time_token
  # Via: one_time_token_path
  def one_time_token
    @user = OneTimeLogin.find_user(sign_in_params[:email])
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
  # TODO spec
  def create
    email = sign_in_params[:email]
    password = sign_in_params[:password]
    remember_me = (sign_in_params[:remember_me] == 'true')

    @user = OneTimeLogin.find_user(email)

    if @user.valid? && @user.validate_authentication_token!(password)
      create_session(@user, remember_me)
      flash[:success] = t('.flash.authentication_success')
      redirect_to my_bet_path
    else
      destroy_session
      flash[:error] = t('.flash.authentication_failed')
      redirect_to login_path
    end
  end

  # GET /logout
  # Via: logout_path
  # TODO spec
  def destroy
    destroy_session
    flash[:notice] = t('.flash.logged_out')
    redirect_to root_path
  end

  private

  def sign_in_params
    params.permit(:email, :password, :remember_me)
  end

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
