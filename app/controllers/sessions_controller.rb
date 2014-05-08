class SessionsController < ApplicationController

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
  end

  # GET /logout
  # Via: logout_path
  def destroy
    # TODO
  end

end
