class PaymentUpdater

  UNPAID_STATUSES = %w( initiated waiting_payment in_analysis ).freeze
  PAID_STATUSES = %w( paid available in_dispute refunded cancelled ).freeze

  attr_reader :transaction, :payment, :previous_payment_status, :next_payment_status

  def initialize(transaction=PagSeguro::Transaction.new, payment_class=Payment, admin_notifier_class=Admin::NotificationsMailer)
    @transaction = transaction
    @payment = payment_class.find_by_reference!(transaction.reference)
    @previous_payment_status = @payment.status
    validate_previous_payment_status!
    @next_payment_status = nil
    @admin_notifier_class = admin_notifier_class
  end

  def update!
    set_payment_attributes_from_transaction
    if valid_status_change?
      payment.save!
      if status_changed?
        admin_notify (strange_status_change? ? :payment_strange_change : :payment_normal_change)
        # TODO notify user that his bet payment was received (if changed from a non-paying status to a paying status)
      end
      true
    else
      admin_notify(:payment_invalid_change)
      false
    end
  end

  private

  def admin_notify(notification_type)
    unless @admin_notifier_class.respond_to?(notification_type)
      raise ArgumentError, "admin_notifier #{@admin_notifier_class} does not have a #{notification_type} method"
    end
    @admin_notifier_class.async_deliver(
      notification_type,
      payment.id,
      previous_payment_status,
      next_payment_status
    )
  end

  def status_changed?
    previous_payment_status != next_payment_status
  end

  def valid_status_change?
    return false if UNPAID_STATUSES.include?(next_payment_status) && PAID_STATUSES.include?(previous_payment_status)
    true
  end

  # it's strange if it's already paid but "goes back" on the status, like from 'available' to 'paid' or from
  # 'cancelled' to 'available', etc.
  def strange_status_change?
    return true if PAID_STATUSES.include?(next_payment_status) &&
      PAID_STATUSES.include?(previous_payment_status) &&
      PAID_STATUSES.find_index(next_payment_status) < PAID_STATUSES.find_index(previous_payment_status)
    false
  end

  def validate_previous_payment_status!
    raise ArgumentError, "payment status is wrong, it is '#{previous_payment_status}'" if previous_payment_status.initiated?
  end

  def status_from_transaction
    PagSeguro::PaymentStatus::STATUSES[transaction.status.id].to_s
  end

  def paid_at_from_transaction
    return nil if (transaction.status.initiated? || transaction.status.waiting_payment? || transaction.status.in_analysis?)
    transaction.created_at.try(:in_time_zone) || Time.zone.now
  end

  def transaction_code_from_transaction
    transaction.code.gsub('-', '')
  end

  def payer_phone_from_transaction
    [
      transaction.sender.try(:phone).try(:area_code),
      transaction.sender.try(:phone).try(:number)
    ].reject(&:blank?).join(' ')
  end

  def set_payment_attributes_from_transaction
    payment.transaction_code = transaction_code_from_transaction if payment.transaction_code.blank?
    payment.status = status_from_transaction
    @next_payment_status = payment.status
    unless (@next_payment_status.initiated? || @next_payment_status.waiting_payment? || @next_payment_status.in_analysis?)
      payment.paid_at = paid_at_from_transaction if payment.paid_at.blank?
      payment.attributes = {
        gross_amount: transaction.gross_amount,
        discount_amount: transaction.discount_amount,
        fee_amount: transaction.fee_amount,
        net_amount: transaction.net_amount,
        extra_amount: transaction.extra_amount,
        installments: transaction.installments,
        escrow_ends_at: transaction.escrow_end_date.try(:in_time_zone),
        payer_name: transaction.sender.try(:name),
        payer_email: transaction.sender.try(:email),
        payer_phone: payer_phone_from_transaction,
      }
    end
  end

end
