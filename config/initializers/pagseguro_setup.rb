PagSeguro.configure do |config|
  config.email = ENV['PAGSEGURO_EMAIL']
  config.token = ENV['PAGSEGURO_TOKEN']
  config.environment = Rails.env.to_sym
end
