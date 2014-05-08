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
    # TODO set locale from logged in user's locale as first option
    I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
  end

  # TODO spec
  # before_action
  def set_time_zone
    # TODO
  end

  # TODO spec
  # before_action
  def require_login
    # TODO
  end

  # TODO spec
  def current_user
    @current_user ||= User.find_by_remember_me_token(cookies.signed[:remember_me_token]) if cookies.signed[:remember_me_token]
  end
  helper_method :current_user

  # TODO spec
  def logged_in?
    !!current_user
  end
  helper_method :logged_in?

end
