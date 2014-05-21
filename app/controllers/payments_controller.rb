class PaymentsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:update]
  skip_before_action :require_login, only: [:update]
  before_action :require_guest, except: [:update]

  before_action :find_bet, only: [:new, :create]
  before_action :find_payment, only: [:new, :create]

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
  # TODO spec
  def update
    code = payment_notification_params[:notificationCode]
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

  def payment_notification_params
    # params == {"notificationCode"=>"34884C-98D02FD02FCB-500404EF8FA4-15DB27", "notificationType"=>"transaction"}
    params.require(:notificationCode)
  end

end
