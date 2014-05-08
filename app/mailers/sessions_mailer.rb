class SessionsMailer < ActionMailer::Base
  default from: ENV['EMAIL_FROM']
  layout 'emails'

  def one_time_login(user, clear_text_temporary_password)
    @user = user
    @password = clear_text_temporary_password
    mail(
      subject: t('.subject', app_name: ENV['APP_NAME']),
      to: @user.email_with_name
    )
  end

end
