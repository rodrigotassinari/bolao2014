class PaymentGatewayRequest
  include Rails.application.routes.url_helpers

  attr_reader :payment
  attr_reader :gateway_request
  attr_reader :gateway_response

  def initialize(payment, gateway_request=PagSeguro::PaymentRequest.new)
    @payment = payment
    @gateway_request = gateway_request
    @gateway_response = nil
    build_gateway_request_from_payment
  end

  def checkout_code
    gateway_response.try(:code)
  end

  def checkout_url
    gateway_response.try(:url)
  end

  def created_at
    gateway_response.try(:created_at)
  end

  def errors
    gateway_response.try(:errors) || {}
  end

  def save
    send_request_to_gateway
    gateway_response.errors.empty?
  end

  private

  def send_request_to_gateway
    @gateway_response = gateway_request.register
  end

  def app_host
    if Rails.env.test?
      # PagSeguro does not accept URL's with port numbers, nor from localhost or 127.0.0.1, nor from 'fake' domains
      'example.com'
    else
      Rails.configuration.action_mailer.default_url_options[:host]
    end
  end

  def notification_host
    if Rails.env.development?
      "pagseguro.#{ENV['ULTRAHOOK_USERNAME']}.ultrahook.com"
    else
      app_host
    end
  end

  def build_gateway_request_from_payment
    gateway_request.reference = payment.reference
    gateway_request.notification_url = payment_notifications_url(host: notification_host)
    gateway_request.redirect_url = bet_payment_url(host: app_host)
    gateway_request.abandon_url = bet_payment_url(host: app_host) # TODO use a diferent page?
    # gateway_request.max_age = ??? # TODO use this?
    # gateway_request.max_uses = ??? # TODO use this?
    # gateway_request.sender = {email: payment.bet.user.email} # TODO use this?
    gateway_request.items << {
      id: payment.bet.id,
      description: I18n.t('activerecord.other.payment.item_description', app_name: ENV['APP_NAME']),
      amount: payment.amount.to_f
    }
  end

end
