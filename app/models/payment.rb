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

  def update_from_pagseguro!(transaction)
  end

  private

  def fetch_pagseguro_transaction
    PagSeguro::Transaction.find_by_code(self.transaction_code)
  end

end
