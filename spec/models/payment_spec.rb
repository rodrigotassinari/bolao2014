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

  describe '#request_and_save!' do
    let(:bet) { create(:bet) }
    context 'when payment status is not `initiated`' do
      subject { build(:initiated_payment, bet: bet, status: 'waiting_payment') }
      it 'raises an error', locale: :pt do
        expect { subject.request_and_save! }.
          to raise_error(
            ActiveRecord::RecordInvalid,
            "A validação falhou: Status não é válido"
          )
      end
    end
    context 'with valid payment status' do
      subject { build(:initiated_payment, bet: bet) }
      let(:fake_request) do
        double('PaymentGatewayRequest',
          save: true,
          errors: [],
          checkout_code: 'some-checkout-code',
          checkout_url: 'some-checkout-url',
          created_at: Time.zone.now
        )
      end
      before(:each) do
        PaymentGatewayRequest.stub(:new).and_return(fake_request)
      end
      context 'on request success' do
        it 'returns true' do
          expect(subject.request_and_save!).to be_true
        end
        it 'creates a payment request on the external payment gateway' do
          PaymentGatewayRequest.should_receive(:new).with(subject).and_return(fake_request)
          fake_request.should_receive(:save).and_return(true)
          subject.request_and_save!
        end
        it 'saves the payment, with the request response information' do
          expect(subject).to be_new_record
          expect { subject.request_and_save! }.to change(Payment, :count).by(1)
          expect(subject).to be_persisted
          subject.reload
          expect(subject.reference).to eql("bet_#{bet.id}")
          expect(subject.status).to be_waiting_payment
          expect(subject.amount).to eql(Payment::DEFAULT_AMOUNT)
          expect(subject.paid_at).to be_nil
          expect(subject.checkout_code).to eql(fake_request.checkout_code)
          expect(subject.checkout_url).to eql(fake_request.checkout_url)
          expect(subject.transaction_code).to be_blank
          expect(subject.gross_amount).to be_nil
          expect(subject.discount_amount).to be_nil
          expect(subject.fee_amount).to be_nil
          expect(subject.net_amount).to be_nil
          expect(subject.extra_amount).to be_nil
          expect(subject.installments).to be_nil
          expect(subject.escrow_ends_at).to be_nil
          expect(subject.payer_name).to be_blank
          expect(subject.payer_email).to be_blank
          expect(subject.payer_phone).to be_blank
        end
      end
      context 'on request failure' do
        let(:fake_request) do
          double('PaymentGatewayRequest',
            save: false,
            errors: ['some errors'],
            checkout_code: nil,
            checkout_url: nil,
            created_at: nil
          )
        end
        it 'returns false' do
          expect(subject.request_and_save!).to be_false
        end
        it 'sets errors', locale: :pt do
          subject.request_and_save!
          expect(subject.errors).to_not be_empty
          expect(subject.errors.get(:payment_gateway)).to eql(['some errors'])
        end
      end
    end
  end

end
