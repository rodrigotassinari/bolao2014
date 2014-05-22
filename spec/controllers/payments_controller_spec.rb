require 'spec_helper'

describe PaymentsController do

  # GET /bet/payment
  # Via: bet_payment_path
  describe '#new' do
    # TODO
  end

  # POST /bet/payment
  # Via: bet_payment_path
  describe '#create' do
    # TODO
  end

  # POST /payment_notifications
  # Via: payment_notifications_path
  describe '#update' do
      context 'when logged in' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      it 'returns redirects with an error message' do
        post :update
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eql(I18n.t('common.already_logged_in'))
      end
    end
    context 'when not logged in' do
      let(:params) { {notificationCode: transaction.code, notificationType: 'transaction'} }
      let(:transaction) { double('PagSeguro::Transaction', code: '34884C-98D02FD02FCB-500404EF8FA4-15DB27', errors: []) }
      before(:each) do
        PagSeguro::Transaction.stub(:find_by_notification_code).and_return(transaction)
      end
      it 'finds the transaction on PagSeguro' do
        PagSeguro::Transaction.
          should_receive(:find_by_notification_code).
          with(transaction.code).
          and_return(transaction)
        post :update, params
      end
      context 'with valid PagSeguro params' do
        it 'queues the payment update from the transaction' do
          PagseguroTransactionWorker.
            should_receive(:perform_async).
            with(transaction.code)
          post :update, params
        end
        it 'responds with an empty success' do
          post :update, params
          expect(response).to be_success
          expect(response.code).to eql('200')
          expect(response.body).to be_blank
        end
      end
      context 'with invalid PagSeguro params' do
        let(:transaction) { double('PagSeguro::Transaction', code: '34884C-98D02FD02FCB-500404EF8FA4-15DB27', errors: ['some error']) }
        it 'responds with an server error' do
          post :update, params
          expect(response).to_not be_success
          expect(response.code).to eql('500')
          expect(response.body).to be_blank
        end
      end
    end
  end

end
