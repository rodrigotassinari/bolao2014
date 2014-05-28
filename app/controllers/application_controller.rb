class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :set_time_zone
  before_action :require_login

  private

  # TODO spec
  # before_action
  def set_locale
    # TODO set locale from user's preferences
    I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
  end

  # TODO spec
  # before_action
  def set_time_zone
    # TODO set time zone from user's preferences
  end

  # TODO spec
  # TODO redirect the user to the URL he wanted to access after sign in (return to)
  # before_action
  def require_login
    unless logged_in?
      flash[:notice] = I18n.t('common.login_required')
      redirect_to login_path
    end
  end

  # TODO spec
  # before_action
  def require_guest
    if logged_in?
      flash[:notice] = I18n.t('common.already_logged_in')
      redirect_to root_path
    end
  end

  # TODO spec
  # before_action
  def require_admin
    unless admin_logged_in?
      flash[:notice] = I18n.t('common.admin_login_required')
      redirect_to root_path
    end
  end

  # TODO spec
  def current_user
    @current_user ||= User.find_by_remember_me_token(cookies.signed[:remember_me_token]) if cookies.signed[:remember_me_token]
  end
  helper_method :current_user

  # TODO spec
  def current_bet
    @current_bet ||= current_user.bet if logged_in?
  end
  helper_method :current_bet

  # TODO spec
  def logged_in?
    !!current_user
  end
  helper_method :logged_in?

  # TODO spec
  def admin_logged_in?
    logged_in? && current_user.admin?
  end
  helper_method :admin_logged_in?

end
