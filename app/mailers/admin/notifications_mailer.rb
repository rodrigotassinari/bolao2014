class Admin::NotificationsMailer < ActionMailer::Base
  layout 'emails'
  default to: ENV['APP_ADMIN_EMAIL']

  def self.async_deliver(method, *args)
    EmailWorker.perform_async(
      'Admin::NotificationsMailer',
      method.to_s,
      args
    )
  end

  # Sent to system admin whenever a payment has it's status changed.
  def payment_normal_change(payment_id, previous_status, next_status)
    load_payment_and_related_models(payment_id, previous_status, next_status)
    mail subject: t('.subject', subject_prefix: subject_prefix, payment_id: @payment.id)
  end

  # Sent to system admin whenever a payment has it's status changed but in a strange way
  # (for example, from 'cancelled' back to 'paid'), could be an error or not.
  def payment_strange_change(payment_id, previous_status, next_status)
    load_payment_and_related_models(payment_id, previous_status, next_status)
    mail subject: t('.subject', subject_prefix: subject_prefix, payment_id: @payment.id)
  end

  # Sent to system admin whenever a payment has been attempted to change it's status in
  # a invalide / erroneous way (from a paid status to an unpaid status); an error in the
  # payment gateway is very likely.
  def payment_invalid_change(payment_id, previous_status, next_status)
    load_payment_and_related_models(payment_id, previous_status, next_status)
    mail subject: t('.subject', subject_prefix: subject_prefix, payment_id: @payment.id)
  end

  private

  def load_payment_and_related_models(payment_id, previous_status, next_status)
    @payment = Payment.find(payment_id)
    @bet = @payment.bet
    @user = @bet.user
    @previous_status = previous_status
    @next_status = next_status
  end

  def subject_prefix
    ENV['APP_SHORT_NAME'].dup.force_encoding('UTF-8')
  end

end
