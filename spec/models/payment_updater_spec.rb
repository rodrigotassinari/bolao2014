require 'spec_helper'

describe PaymentUpdater do

  describe '.new' do
    let(:payment) { create(:unpaid_payment) }
    let(:transaction) { build_transaction(reference: payment.reference) }
    it 'sets the transaction attribute' do
      updater = described_class.new(transaction)
      expect(updater.transaction).to eql(transaction)
    end
    it 'sets the payment attribute from the transaction reference' do
      updater = described_class.new(transaction)
      expect(updater.payment).to eql(payment)
    end
    it 'raise an error if the payment can not be found' do
      transaction.should_receive(:reference).and_return('foobar')
      expect { described_class.new(transaction) }.
        to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#update!' do
    # TODO
  end

  def build_transaction(attributes={})
    # https://github.com/rtopitt/pagseguro-ruby/blob/ec430c93bef91a2e8eb66a4c22e8181fdb32b403/lib/pagseguro/transaction.rb
    double(
      'PagSeguro::Transaction',
      cancellation_source: attributes[:cancellation_source],
      code: attributes[:code],
      created_at: attributes[:created_at],
      discount_amount: attributes[:discount_amount],
      errors: (attributes[:errors] || []),
      escrow_end_date: attributes[:escrow_end_date],
      extra_amount: attributes[:extra_amount],
      fee_amount: attributes[:fee_amount],
      gross_amount: attributes[:gross_amount],
      installments: attributes[:installments],
      net_amount: attributes[:net_amount],
      payment_link: attributes[:payment_link],
      payment_method: attributes[:payment_method],
      reference: attributes[:reference],
      reference: attributes[:reference],
      sender: attributes[:sender],
      shipping: attributes[:shipping],
      status: attributes[:status],
      type_id: attributes[:type_id],
      updated_at: attributes[:updated_at],
    )
  end

end

