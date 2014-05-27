class PaymentsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:update]
  skip_before_action :require_login, only: [:update]
  before_action :require_guest, only: [:update]

  before_action :find_bet, except: [:update]
  before_action :find_payment, except: [:update]

  # GET /my_bet/payment
  # Via: my_bet_payment_path
  #
  # Shows the payment form / information before redirecting to the payment gateway.
  def new
  end

  # POST /my_bet/payment
  # Via: my_bet_payment_path
  #
  # Creates the payment data on the payment gateway and redirects the user to proceed with paying for the bet.
  def create
    if @_payment.request_and_save!
      redirect_to @_payment.checkout_url
    else
      # TODO notify admin of gateway @_payment.errors.get(:payment_gateway)
      Rails.logger.error @_payment.errors.full_messages.join(', ')
      flash[:error] = t('.error_with_gateway')
      redirect_to my_bet_payment_path
    end
  rescue ActiveRecord::RecordInvalid => invalid
    # @_payment was not in initiated stage or was invalid
    # TODO notify admin of @_payment.errors
    Rails.logger.error @_payment.errors.full_messages.join(', ')
    flash[:error] = t('.internal_error')
    redirect_to my_bet_payment_path
  end

  # POST /payment_notifications
  # Via: payment_notifications_path
  #
  # Receives payment notifications from the payment gateway and updates local bet payments.
  def update
    code = params.require(:notificationCode)
    transaction = PagSeguro::Transaction.find_by_notification_code(code)
    if transaction.errors.empty?
      PagseguroTransactionWorker.perform_async(code)
      render nothing: true, status: :ok
    else
      # someone is posting erroneous data to us (or PagSeguro is bugged)
      # TODO raise error and/or log issue
      render nothing: true, status: :internal_server_error
    end
  end

  private

  def find_bet
    @_bet = current_user.bet
    @bet = BetPresenter.new(@_bet)
  end

  def find_payment
    @_payment = Payment.find_or_initialize_with_defaults(@_bet)
    @payment = PaymentPresenter.new(@_payment)
  end

end
