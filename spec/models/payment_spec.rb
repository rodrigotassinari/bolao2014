require 'spec_helper'

describe Payment do

  context 'associations' do
    it { should belong_to(:bet) }
  end

  context 'validations' do
    it { should validate_presence_of(:bet) }
    it { should validate_uniqueness_of(:bet_id) }

    it { should validate_presence_of(:reference) }
    it { should validate_uniqueness_of(:reference) }

    it { should validate_presence_of(:status) }
    it { should ensure_inclusion_of(:status).in_array(Payment::STATUSES) }

    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_equal_to(Payment::DEFAULT_AMOUNT) }

    it { should validate_numericality_of(:gross_amount).is_greater_than(0.00) }
    it { should validate_numericality_of(:discount_amount).is_greater_than_or_equal_to(0.00) }
    it { should validate_numericality_of(:fee_amount).is_greater_than_or_equal_to(0.00) }
    it { should validate_numericality_of(:net_amount).is_greater_than_or_equal_to(0.00) }
    it { should validate_numericality_of(:extra_amount).is_greater_than_or_equal_to(0.00) }

    it { should validate_numericality_of(:installments).only_integer.is_greater_than_or_equal_to(1) }
  end

  describe '.find_or_initialize_with_defaults' do
    let!(:bet) { create(:bet) }
    it 'returns a new Payment with default values' do
      payment = Payment.find_or_initialize_with_defaults(bet)
      expect(payment).to be_new_record
      expect(payment.reference).to eql("bet_#{bet.id}")
      expect(payment.status).to eql('initiated')
      expect(payment.amount).to eql(Payment::DEFAULT_AMOUNT)
    end
    it 'finds and returns an existing payment' do
      existing_payment = create(:unpaid_payment, bet: bet)
      payment = Payment.find_or_initialize_with_defaults(bet)
      expect(payment).to be_persisted
      expect(payment.reference).to eql("bet_#{bet.id}")
      expect(payment.status).to eql('waiting_payment')
      expect(payment.amount).to eql(Payment::DEFAULT_AMOUNT)
      expect(payment.checkout_code).to_not be_blank
    end
  end

end
