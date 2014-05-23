class Payment < ActiveRecord::Base

  # from https://github.com/rtopitt/pagseguro-ruby/blob/ec430c93bef91a2e8eb66a4c22e8181fdb32b403/lib/pagseguro/payment_status.rb#L3
  STATUSES = %w( initiated waiting_payment in_analysis paid available in_dispute refunded cancelled ).freeze
  DEFAULT_AMOUNT = BigDecimal(ENV.fetch('APP_BET_COST', '25')).freeze

  belongs_to :bet

  validates :bet,
    presence: true
  validates :bet_id,
    uniqueness: true

  validates :reference,
    presence: true,
    uniqueness: true

  validates :status,
    presence: true,
    inclusion: { in: STATUSES, allow_blank: true }

  validates :amount,
    presence: true,
    numericality: { equal_to: DEFAULT_AMOUNT, allow_blank: true }

  validates :gross_amount,
    numericality: { greater_than: 0.00, allow_blank: true }
  validates :discount_amount,
    numericality: { greater_than_or_equal_to: 0.00, allow_blank: true }
  validates :fee_amount,
    numericality: { greater_than_or_equal_to: 0.00, allow_blank: true }
  validates :net_amount,
    numericality: { greater_than_or_equal_to: 0.00, allow_blank: true }
  validates :extra_amount,
    numericality: { greater_than_or_equal_to: 0.00, allow_blank: true }

  validates :installments,
    numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_blank: true }

  # TODO spec
  def escrow_end_date=(value)
    self.escrow_ends_at = value
  end

  # TODO spec
  def pagseguro_transaction
    return if self.transaction_code.blank?
    @pagseguro_transaction ||= fetch_pagseguro_transaction
  end
  # TODO spec
  def pagseguro_transaction!
    return if self.transaction_code.blank?
    @pagseguro_transaction = fetch_pagseguro_transaction
    @pagseguro_transaction
  end

  def self.find_or_initialize_with_defaults(seed_bet)
    self.find_or_initialize_by(bet: seed_bet) do |p|
      p.reference = "bet_#{seed_bet.id}"
      p.status = STATUSES.first
      p.amount = DEFAULT_AMOUNT
    end
  end

  # TODO spec
  def status
    ActiveSupport::StringInquirer.new(read_attribute(:status)) unless read_attribute(:status).blank?
  end

  # TODO spec
  def paid?
    self.persisted? &&
      self.paid_at.present? &&
      !self.status.initiated? &&
      !self.status.waiting_payment? &&
      !self.status.in_analysis?
  end

  # TODO spec
  def paying?
    self.persisted? &&
      (self.status.initiated? || self.status.waiting_payment? || self.status.in_analysis?)
  end

  def request_and_save!
    validate_pre_pay_status!
    request = PaymentGatewayRequest.new(self)
    if request.save
      self.status = 'waiting_payment'
      self.checkout_code = request.checkout_code
      self.checkout_url = request.checkout_url
      self.save!
      notify_admin('initiated', 'waiting_payment')
      true
    else
      self.errors.add(:payment_gateway, request.errors.join(', '))
      # TODO notify admin?
      false
    end
  end

  # Sets payment as paid mannually, without going through the payment gateway. For cases
  # when people give you the money in cash personally.
  # TODO spec
  def manual_pay!
    validate_pre_pay_status!
    self.status = 'available'
    self.paid_at = Time.zone.now
    self.amount = DEFAULT_AMOUNT
    self.gross_amount = DEFAULT_AMOUNT
    self.discount_amount 0.0
    self.fee_amount = 0.0
    self.extra_amount = 0.0
    self.net_amount = DEFAULT_AMOUNT
    self.installments = 1
    self.escrow_ends_at = self.paid_at
    self.save!
  end

  private

  def validate_pre_pay_status!
    unless self.status.initiated?
      self.errors.add(:status, :invalid)
      raise ActiveRecord::RecordInvalid.new(self)
    end
    unless self.valid?
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end

  def fetch_pagseguro_transaction
    PagSeguro::Transaction.find_by_code(self.transaction_code)
  end

  def notify_admin(from_status, to_status)
    Admin::NotificationsMailer.async_deliver(
      :payment_normal_change,
      self.id,
      from_status,
      to_status
    )
  end

end
