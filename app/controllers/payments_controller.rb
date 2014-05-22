class PaymentsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:update]
  skip_before_action :require_login, only: [:update]
  before_action :require_guest, only: [:update]

  before_action :find_bet, except: [:update]
  before_action :find_payment, except: [:update]

  # GET /bet/payment
  # Via: bet_payment_path
  #
  # Shows the payment form / information before redirecting to the payment gateway.
  # TODO spec
  def new
    # TODO
  end

  # POST /bet/payment
  # Via: bet_payment_path
  #
  # Creates the payment data on the payment gateway and redirects the user to proceed with paying for the bet.
  # TODO spec
  def create
    # TODO
    # @_payment.pay!
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
