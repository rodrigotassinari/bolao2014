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
    if @email.present? && @email =~ User::EMAIL_REGEX
      render :one_time_token
    else
      flash[:error] = (@email.present? ? t('.flash.email_invalid_error') : t('.flash.email_required_error'))
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
