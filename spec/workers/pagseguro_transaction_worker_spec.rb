require 'spec_helper'

describe PagseguroTransactionWorker do

  it 'uses the `low` queue' do
    expect(described_class.get_sidekiq_options['queue']).to eq(:low)
  end

  it 'is retryable' do
    expect(described_class.get_sidekiq_options['retry']).to be_true
  end

  it 'saves error backtrace to show on the web ui' do
    expect(described_class.get_sidekiq_options['backtrace']).to be_true
  end

  describe '#perform' do
    let(:notification_code) { '34884C-98D02FD02FCB-500404EF8FA4-15DB27' }
    let(:reference) { 'bet_42' }
    let(:transaction) { double('PagSeguro::Transaction', errors: [], code: notification_code, reference: reference) }

    before(:each) do
      PagSeguro::Transaction.stub(:find_by_notification_code).and_return(transaction)
      PaymentUpdater.stub(:new).and_return( double('PaymentUpdater').as_null_object )
    end

    it 'fetches the transaction info from PagSeguro' do
      PagSeguro::Transaction.
        should_receive(:find_by_notification_code).
        with(notification_code).
        and_return(transaction)
      subject.perform(notification_code)
    end
    context 'when transaction is valid' do
      it 'processes the transaction' do
        updater = double('PaymentUpdater')
        PaymentUpdater.should_receive(:new).with(transaction).and_return(updater)
        updater.should_receive(:update!)
        subject.perform(notification_code)
      end
    end
    context 'when transaction is NOT valid' do
      let(:transaction) { double('PagSeguro::Transaction', errors: ['foo', 'bar'], code: notification_code, reference: reference) }
      it 'raises and error' do
        expect { subject.perform(notification_code) }.
          to raise_error("something wrong at PagSeguro, notification_code=34884C-98D02FD02FCB-500404EF8FA4-15DB27, errors: foo,bar")
      end
    end
  end

end
