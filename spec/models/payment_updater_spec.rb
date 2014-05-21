require 'spec_helper'

describe PaymentUpdater do

  describe '.new' do
    context 'with valid arguments' do
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
      it 'sets the payment statuses attributes' do
        updater = described_class.new(transaction)
        expect(updater.previous_payment_status).to eql(payment.status)
        expect(updater.next_payment_status).to be_nil
      end
    end
    context 'when payment can not be found' do
      let(:payment) { create(:unpaid_payment) }
      let(:transaction) { build_transaction(reference: 'foobar') }
      it 'raises an error' do
        expect { described_class.new(transaction) }.
          to raise_error(ActiveRecord::RecordNotFound)
      end
    end
    context 'when payment can not have been sent to PagSeguro yet' do
      let(:payment) { create(:initiated_payment) }
      let(:transaction) { build_transaction(reference: payment.reference) }
      it 'raises an error' do
        expect { described_class.new(transaction) }.
          to raise_error(ArgumentError, "payment status is wrong, it is 'initiated'")
      end
    end
  end

  describe '#update!' do
    let(:now) { Time.zone.now }
    let(:payment_class) { Payment }
    let(:admin_notifier_class) { Admin::NotificationsMailer }
    before(:each) do
      Timecop.freeze(now)
    end
    after(:each) do
      Timecop.return
    end
    let(:base_transaction_attributes) do
      {
        code: 'D0DCE84E-20AF-41A6-8C60-70F79815D610',
        reference: payment.reference,
        sender: {name: 'Edson Arantes do Nascimento', email: 'pele@example.com', ddd: '21', phone: '555-1234'},
        gross_amount: 25.00,
        discount_amount: 0.00,
        extra_amount: 0.00,
        fee_amount: 1.65,
        net_amount: 23.35,
        installments: 1,
        created_at: now - 1.hour,
        updated_at: now,
      }
    end
    subject { described_class.new(transaction) }
    describe 'with an unpaid (waiting_payment) payment' do
      let(:payment) { create(:unpaid_payment, status: 'waiting_payment') }
      context 'when transaction status = waiting_payment' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'waiting_payment')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_unpaid_payment_attributes(payment, transaction)
        end
        it 'DOES NOT notify the admin' do # no change in status
          admin_notifier_class.should_not_receive(:async_deliver)
          subject.update!
        end
      end
      context 'when transaction status = in_analysis' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'in_analysis')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_unpaid_payment_attributes(payment, transaction)
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'waiting_payment', 'in_analysis')
          subject.update!
        end
      end
      context 'when transaction status = paid' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'paid')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          expect(payment.paid_at.to_i).to eql(transaction.created_at.to_i)
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'waiting_payment', 'paid')
          subject.update!
        end
      end
      context 'when transaction status = available' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'available')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          expect(payment.paid_at.to_i).to eql(transaction.created_at.to_i)
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'waiting_payment', 'available')
          subject.update!
        end
      end
      context 'when transaction status = in_dispute' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'in_dispute')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          expect(payment.paid_at.to_i).to eql(transaction.created_at.to_i)
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'waiting_payment', 'in_dispute')
          subject.update!
        end
      end
      context 'when transaction status = refunded' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'refunded')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          expect(payment.paid_at.to_i).to eql(transaction.created_at.to_i)
          # expect(payment.refunded_at.to_i).to eql(transaction.updated_at.to_i) # TODO
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'waiting_payment', 'refunded')
          subject.update!
        end
      end
      context 'when transaction status = cancelled' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'cancelled', cancellation_source: 'Foo Bar')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          expect(payment.paid_at.to_i).to eql(transaction.created_at.to_i)
          # expect(payment.cancelled_at.to_i).to eql(transaction.updated_at.to_i) # TODO
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'waiting_payment', 'cancelled')
          subject.update!
        end
      end
    end
    describe 'with an unpaid (in_analysis) payment' do
      let(:payment) { create(:unpaid_payment, status: 'in_analysis') }
      context 'when transaction status = waiting_payment' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'waiting_payment')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_unpaid_payment_attributes(payment, transaction)
        end
        it 'notifies the admin' do # the analysis "failed", went back to 'waiting_payment'
          test_normal_admin_notification(admin_notifier_class, payment, 'in_analysis', 'waiting_payment')
          subject.update!
        end
      end
      context 'when transaction status = in_analysis' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'in_analysis')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_unpaid_payment_attributes(payment, transaction)
        end
        it 'DOES NOT notify the admin' do # no change in status
          admin_notifier_class.should_not_receive(:async_deliver)
          subject.update!
        end
      end
      context 'when transaction status = paid' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'paid')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          expect(payment.paid_at.to_i).to eql(transaction.created_at.to_i)
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'in_analysis', 'paid')
          subject.update!
        end
      end
      context 'when transaction status = available' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'available')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          expect(payment.paid_at.to_i).to eql(transaction.created_at.to_i)
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'in_analysis', 'available')
          subject.update!
        end
      end
      context 'when transaction status = in_dispute' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'in_dispute')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          expect(payment.paid_at.to_i).to eql(transaction.created_at.to_i)
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'in_analysis', 'in_dispute')
          subject.update!
        end
      end
      context 'when transaction status = refunded' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'refunded')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          expect(payment.paid_at.to_i).to eql(transaction.created_at.to_i)
          # expect(payment.refunded_at.to_i).to eql(transaction.updated_at.to_i) # TODO
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'in_analysis', 'refunded')
          subject.update!
        end
      end
      context 'when transaction status = cancelled' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'cancelled', cancellation_source: 'Foo Bar')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          expect(payment.paid_at.to_i).to eql(transaction.created_at.to_i)
          # expect(payment.cancelled_at.to_i).to eql(transaction.updated_at.to_i) # TODO
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'in_analysis', 'cancelled')
          subject.update!
        end
      end
    end
    describe 'with a paid (paid) payment' do
      let(:payment) { create(:paid_payment, transaction_code: 'D0DCE84E20AF41A68C6070F79815D610', status: 'paid') }
      context 'when transaction status = waiting_payment' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'waiting_payment')) }
        it 'DOES NOT update the payment' do
          expect(subject.update!).to be_false
          payment.reload
          expect(payment.status).to eql('paid')
          expect(payment.paid_at).to_not be_nil
        end
        it 'notifies the admin' do # something is wrong, a paid bet changed back to 'waiting_payment'
          test_invalid_admin_notification(admin_notifier_class, payment, 'paid', 'waiting_payment')
          subject.update!
        end
      end
      context 'when transaction status = in_analysis' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'in_analysis')) }
        it 'DOES NOT update the payment' do
          expect(subject.update!).to be_false
          payment.reload
          expect(payment.status).to eql('paid')
          expect(payment.paid_at).to_not be_nil
        end
        it 'notifies the admin' do # something is wrong, a paid bet changed back to 'in_analysis'
          test_invalid_admin_notification(admin_notifier_class, payment, 'paid', 'in_analysis')
          subject.update!
        end
      end
      context 'when transaction status = paid' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'paid')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
        end
        it 'DOES NOT notify the admin' do # no change in status
          admin_notifier_class.should_not_receive(:async_deliver)
          subject.update!
        end
      end
      context 'when transaction status = available' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'available')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'paid', 'available')
          subject.update!
        end
      end
      context 'when transaction status = in_dispute' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'in_dispute')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'paid', 'in_dispute')
          subject.update!
        end
      end
      context 'when transaction status = refunded' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'refunded')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          # expect(payment.refunded_at.to_i).to eql(transaction.updated_at.to_i) # TODO
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'paid', 'refunded')
          subject.update!
        end
      end
      context 'when transaction status = cancelled' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'cancelled', cancellation_source: 'Foo Bar')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          # expect(payment.cancelled_at.to_i).to eql(transaction.updated_at.to_i) # TODO
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'paid', 'cancelled')
          subject.update!
        end
      end
    end
    describe 'with a paid (available) payment' do
      let(:payment) { create(:paid_payment, transaction_code: 'D0DCE84E20AF41A68C6070F79815D610', status: 'available') }
      context 'when transaction status = waiting_payment' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'waiting_payment')) }
        it 'DOES NOT update the payment' do
          expect(subject.update!).to be_false
          payment.reload
          expect(payment.status).to eql('available')
          expect(payment.paid_at).to_not be_nil
        end
        it 'notifies the admin' do # something is wrong, a paid bet changed back to 'waiting_payment'
          test_invalid_admin_notification(admin_notifier_class, payment, 'available', 'waiting_payment')
          subject.update!
        end
      end
      context 'when transaction status = in_analysis' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'in_analysis')) }
        it 'DOES NOT update the payment' do
          expect(subject.update!).to be_false
          payment.reload
          expect(payment.status).to eql('available')
          expect(payment.paid_at).to_not be_nil
        end
        it 'notifies the admin' do # something is wrong, a paid bet changed back to 'in_analysis'
          test_invalid_admin_notification(admin_notifier_class, payment, 'available', 'in_analysis')
          subject.update!
        end
      end
      context 'when transaction status = paid' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'paid')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
        end
        it 'notifies the admin' do # potential error? why would an available go back to paid?
          test_strange_admin_notification(admin_notifier_class, payment, 'available', 'paid')
          subject.update!
        end
      end
      context 'when transaction status = available' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'available')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
        end
        it 'DOES NOT notify the admin' do # no change in status
          admin_notifier_class.should_not_receive(:async_deliver)
          subject.update!
        end
      end
      context 'when transaction status = in_dispute' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'in_dispute')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'available', 'in_dispute')
          subject.update!
        end
      end
      context 'when transaction status = refunded' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'refunded')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          # expect(payment.refunded_at.to_i).to eql(transaction.updated_at.to_i) # TODO
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'available', 'refunded')
          subject.update!
        end
      end
      context 'when transaction status = cancelled' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'cancelled', cancellation_source: 'Foo Bar')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          # expect(payment.cancelled_at.to_i).to eql(transaction.updated_at.to_i) # TODO
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'available', 'cancelled')
          subject.update!
        end
      end
    end
    describe 'with a paid (in_dispute) payment' do
      let(:payment) { create(:paid_payment, transaction_code: 'D0DCE84E20AF41A68C6070F79815D610', status: 'in_dispute') }
      context 'when transaction status = waiting_payment' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'waiting_payment')) }
        it 'DOES NOT update the payment' do
          expect(subject.update!).to be_false
          payment.reload
          expect(payment.status).to eql('in_dispute')
          expect(payment.paid_at).to_not be_nil
        end
        it 'notifies the admin' do # something is wrong, a paid bet changed back to 'waiting_payment'
          test_invalid_admin_notification(admin_notifier_class, payment, 'in_dispute', 'waiting_payment')
          subject.update!
        end
      end
      context 'when transaction status = in_analysis' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'in_analysis')) }
        it 'DOES NOT update the payment' do
          expect(subject.update!).to be_false
          payment.reload
          expect(payment.status).to eql('in_dispute')
          expect(payment.paid_at).to_not be_nil
        end
        it 'notifies the admin' do # something is wrong, a paid bet changed back to 'in_analysis'
          test_invalid_admin_notification(admin_notifier_class, payment, 'in_dispute', 'in_analysis')
          subject.update!
        end
      end
      context 'when transaction status = paid' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'paid')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
        end
        it 'notifies the admin' do # potential error? why would an in_dispute go back to paid?
          test_strange_admin_notification(admin_notifier_class, payment, 'in_dispute', 'paid')
          subject.update!
        end
      end
      context 'when transaction status = available' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'available')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
        end
        it 'notifies the admin' do # potential error? why would an in_dispute go back to available?
          test_strange_admin_notification(admin_notifier_class, payment, 'in_dispute', 'available')
          subject.update!
        end
      end
      context 'when transaction status = in_dispute' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'in_dispute')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
        end
        it 'DOES NOT notify the admin' do # no change in status
          admin_notifier_class.should_not_receive(:async_deliver)
          subject.update!
        end
      end
      context 'when transaction status = refunded' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'refunded')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          # expect(payment.refunded_at.to_i).to eql(transaction.updated_at.to_i) # TODO
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'in_dispute', 'refunded')
          subject.update!
        end
      end
      context 'when transaction status = cancelled' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'cancelled', cancellation_source: 'Foo Bar')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          # expect(payment.cancelled_at.to_i).to eql(transaction.updated_at.to_i) # TODO
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'in_dispute', 'cancelled')
          subject.update!
        end
      end
    end
    describe 'with a paid (refunded) payment' do
      let(:payment) { create(:paid_payment, transaction_code: 'D0DCE84E20AF41A68C6070F79815D610', status: 'refunded') }
      context 'when transaction status = waiting_payment' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'waiting_payment')) }
        it 'DOES NOT update the payment' do
          expect(subject.update!).to be_false
          payment.reload
          expect(payment.status).to eql('refunded')
          expect(payment.paid_at).to_not be_nil
        end
        it 'notifies the admin' do # something is wrong, a paid bet changed back to 'waiting_payment'
          test_invalid_admin_notification(admin_notifier_class, payment, 'refunded', 'waiting_payment')
          subject.update!
        end
      end
      context 'when transaction status = in_analysis' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'in_analysis')) }
        it 'DOES NOT update the payment' do
          expect(subject.update!).to be_false
          payment.reload
          expect(payment.status).to eql('refunded')
          expect(payment.paid_at).to_not be_nil
        end
        it 'notifies the admin' do # something is wrong, a paid bet changed back to 'in_analysis'
          test_invalid_admin_notification(admin_notifier_class, payment, 'refunded', 'in_analysis')
          subject.update!
        end
      end
      context 'when transaction status = paid' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'paid')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
        end
        it 'notifies the admin' do # potential error? why would an refunded go back to paid?
          test_strange_admin_notification(admin_notifier_class, payment, 'refunded', 'paid')
          subject.update!
        end
      end
      context 'when transaction status = available' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'available')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
        end
        it 'notifies the admin' do # potential error? why would an refunded go back to available?
          test_strange_admin_notification(admin_notifier_class, payment, 'refunded', 'available')
          subject.update!
        end
      end
      context 'when transaction status = in_dispute' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'in_dispute')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
        end
        it 'notifies the admin' do # potential error? why would an refunded go back to in_dispute?
          test_strange_admin_notification(admin_notifier_class, payment, 'refunded', 'in_dispute')
          subject.update!
        end
      end
      context 'when transaction status = refunded' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'refunded')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          # expect(payment.refunded_at.to_i).to eql(transaction.updated_at.to_i) # TODO
        end
        it 'DOES NOT notify the admin' do # no change in status
          admin_notifier_class.should_not_receive(:async_deliver)
          subject.update!
        end
      end
      context 'when transaction status = cancelled' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'cancelled', cancellation_source: 'Foo Bar')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          # expect(payment.cancelled_at.to_i).to eql(transaction.updated_at.to_i) # TODO
        end
        it 'notifies the admin' do
          test_normal_admin_notification(admin_notifier_class, payment, 'refunded', 'cancelled')
          subject.update!
        end
      end
    end
    describe 'with a paid (cancelled) payment' do
      let(:payment) { create(:paid_payment, transaction_code: 'D0DCE84E20AF41A68C6070F79815D610', status: 'cancelled') }
      context 'when transaction status = waiting_payment' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'waiting_payment')) }
        it 'DOES NOT update the payment' do
          expect(subject.update!).to be_false
          payment.reload
          expect(payment.status).to eql('cancelled')
          expect(payment.paid_at).to_not be_nil
        end
        it 'notifies the admin' do # something is wrong, a paid bet changed back to 'waiting_payment'
          test_invalid_admin_notification(admin_notifier_class, payment, 'cancelled', 'waiting_payment')
          subject.update!
        end
      end
      context 'when transaction status = in_analysis' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'in_analysis')) }
        it 'DOES NOT update the payment' do
          expect(subject.update!).to be_false
          payment.reload
          expect(payment.status).to eql('cancelled')
          expect(payment.paid_at).to_not be_nil
        end
        it 'notifies the admin' do # something is wrong, a paid bet changed back to 'in_analysis'
          test_invalid_admin_notification(admin_notifier_class, payment, 'cancelled', 'in_analysis')
          subject.update!
        end
      end
      context 'when transaction status = paid' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'paid')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
        end
        it 'notifies the admin' do # potential error? why would an cancelled go back to paid?
          test_strange_admin_notification(admin_notifier_class, payment, 'cancelled', 'paid')
          subject.update!
        end
      end
      context 'when transaction status = available' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'available')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
        end
        it 'notifies the admin' do # potential error? why would an cancelled go back to available?
          test_strange_admin_notification(admin_notifier_class, payment, 'cancelled', 'available')
          subject.update!
        end
      end
      context 'when transaction status = in_dispute' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'in_dispute')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
        end
        it 'notifies the admin' do # potential error? why would an cancelled go back to in_dispute?
          test_strange_admin_notification(admin_notifier_class, payment, 'cancelled', 'in_dispute')
          subject.update!
        end
      end
      context 'when transaction status = refunded' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'refunded')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          # expect(payment.refunded_at.to_i).to eql(transaction.updated_at.to_i) # TODO
        end
        it 'notifies the admin' do # potential error? why would an cancelled go back to refunded?
          test_strange_admin_notification(admin_notifier_class, payment, 'cancelled', 'refunded')
          subject.update!
        end
      end
      context 'when transaction status = cancelled' do
        let(:transaction) { build_transaction(base_transaction_attributes.merge(status: 'cancelled', cancellation_source: 'Foo Bar')) }
        it 'updates the payment' do
          expect(subject.update!).to be_true
          payment.reload
          test_paid_payment_attributes(payment, transaction)
          # expect(payment.cancelled_at.to_i).to eql(transaction.updated_at.to_i) # TODO
        end
        it 'DOES NOT notify the admin' do # no change in status
          admin_notifier_class.should_not_receive(:async_deliver)
          subject.update!
        end
      end
    end
  end

  def build_transaction(attributes={})
    # https://github.com/rtopitt/pagseguro-ruby/blob/ec430c93bef91a2e8eb66a4c22e8181fdb32b403/lib/pagseguro/transaction.rb
    double(
      'PagSeguro::Transaction',
      cancellation_source: attributes[:cancellation_source],
      code: attributes[:code],
      created_at: attributes[:created_at],
      discount_amount: BigDecimal(attributes[:discount_amount].to_s),
      errors: (attributes[:errors] || []),
      escrow_end_date: attributes[:escrow_end_date],
      extra_amount: BigDecimal(attributes[:extra_amount].to_s),
      fee_amount: BigDecimal(attributes[:fee_amount].to_s),
      gross_amount: BigDecimal(attributes[:gross_amount].to_s),
      installments: attributes[:installments],
      net_amount: BigDecimal(attributes[:net_amount].to_s),
      payment_link: attributes[:payment_link],
      payment_method: attributes[:payment_method],
      reference: attributes[:reference],
      sender: mock_transaction_sender(attributes[:sender]),
      shipping: attributes[:shipping],
      status: mock_transaction_status(attributes[:status]),
      type_id: attributes[:type_id],
      updated_at: attributes[:updated_at],
    )
  end

  def mock_transaction_status(status=nil)
    return if status.blank?
    ids = {
      'initiated' => '0',
      'waiting_payment' => '1',
      'in_analysis' => '2',
      'paid' => '3',
      'available' => '4',
      'in_dispute' => '5',
      'refunded' => '6',
      'cancelled' => '7',
    }
    obj = ::PagSeguro::PaymentStatus.new(ids[status.to_s])
    obj.stub(:to_s).and_return(status.to_s)
    obj
  end

  def mock_transaction_sender(attributes={})
    return if attributes.nil? || attributes.empty?
    double(
      'PagSeguro::Sender',
      name: attributes[:name],
      email: attributes[:email],
      phone: double('PagSeguro::Phone', area_code: attributes[:ddd], number: attributes[:phone])
    )
  end

  def test_unpaid_payment_attributes(payment, transaction)
    expect(payment.transaction_code).to eql(transaction.code.gsub('-', ''))
    expect(payment.status).to eql(transaction.status.to_s)
    expect(payment.paid_at).to be_nil
    expect(payment.gross_amount).to be_nil
    expect(payment.discount_amount).to be_nil
    expect(payment.fee_amount).to be_nil
    expect(payment.net_amount).to be_nil
    expect(payment.extra_amount).to be_nil
    expect(payment.installments).to be_nil
    expect(payment.escrow_ends_at).to be_nil
    expect(payment.payer_name).to be_nil
    expect(payment.payer_email).to be_nil
    expect(payment.payer_phone).to be_nil
  end

  def test_paid_payment_attributes(payment, transaction)
    expect(payment.transaction_code).to eql(transaction.code.gsub('-', ''))
    expect(payment.status).to eql(transaction.status.to_s)
    expect(payment.paid_at).to_not be_nil
    expect(payment.gross_amount).to eql(transaction.gross_amount)
    expect(payment.discount_amount).to eql(transaction.discount_amount)
    expect(payment.fee_amount).to eql(transaction.fee_amount)
    expect(payment.net_amount).to eql(transaction.net_amount)
    expect(payment.extra_amount).to eql(transaction.extra_amount)
    expect(payment.installments).to eql(transaction.installments)
    expect(payment.escrow_ends_at.to_i).to eql(transaction.escrow_end_date.to_i)
    expect(payment.payer_name).to eql(transaction.sender.name)
    expect(payment.payer_email).to eql(transaction.sender.email)
    expect(payment.payer_phone).to eql("#{transaction.sender.phone.area_code} #{transaction.sender.phone.number}")
  end

  def test_normal_admin_notification(admin_notifier_class, payment, from_status, to_status)
    admin_notifier_class.
      should_receive(:async_deliver).
      with(
        :payment_normal_change,
        payment.id,
        from_status,
        to_status
      )
  end

  def test_invalid_admin_notification(admin_notifier_class, payment, from_status, to_status)
    admin_notifier_class.
      should_receive(:async_deliver).
      with(
        :payment_invalid_change,
        payment.id,
        from_status,
        to_status
      )
  end

  def test_strange_admin_notification(admin_notifier_class, payment, from_status, to_status)
    admin_notifier_class.
      should_receive(:async_deliver).
      with(
        :payment_strange_change,
        payment.id,
        from_status,
        to_status
      )
  end

end
