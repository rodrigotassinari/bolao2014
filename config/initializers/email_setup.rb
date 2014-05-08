Rails.application.configure do

  unless Rails.env.test?
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      :user_name => ENV['EMAIL_SMTP_USER_NAME'],
      :password => ENV['EMAIL_SMTP_PASSWORD'],
      :address => ENV['EMAIL_SMTP_ADDRESS'],
      :domain => ENV['EMAIL_SMTP_DOMAIN'],
      :port => ENV['EMAIL_SMTP_PORT'],
      :authentication => ENV['EMAIL_SMTP_AUTHENTICATION'].to_sym,
      :enable_starttls_auto => (ENV['EMAIL_SMTP_ENABLE_STARTTLS_AUTO'] == 'true')
    }
  end

  config.action_mailer.default_options = { from: ENV['EMAIL_FROM'] }

end
