require 'spec_helper'

describe PaymentsController do

  # GET /bet/payment
  # Via: bet_payment_path
  describe '#new' do
    context 'when not logged in' do
      it 'redirects with an error message' do
        get :new
        expect(response).to be_redirect
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to eql(I18n.t('common.login_required'))
      end
    end
    context 'when logged in' do
      let(:bet) { create(:bet) }
      let(:user) { bet.user }
      before(:each) { login_user(user) }
      it 'finds the current user bet' do
        get :new
        expect(assigns(:_bet)).to eql(bet)
        expect(assigns(:bet)).to be_instance_of(BetPresenter)
      end
      context 'when the bet has not been paid' do
        it 'builds and assigns a new payment' do
          get :new
          payment = assigns(:_payment)
          expect(payment).to be_instance_of(Payment)
          expect(payment).to be_new_record
          expect(payment.bet).to eql(bet)
          expect(payment.reference).to eql("bet_#{bet.id}")
          expect(payment.status).to be_initiated
          expect(payment.amount).to eql(Payment::DEFAULT_AMOUNT)
          expect(assigns(:payment)).to be_instance_of(PaymentPresenter)
        end
      end
      context 'when the bet is being paid' do
        let!(:payment) { create(:unpaid_payment, bet: bet) }
        it 'finds and assigns the payment' do
          get :new
          expect(assigns(:_payment)).to eql(payment)
          expect(assigns(:payment)).to be_instance_of(PaymentPresenter)
        end
      end
      context 'when the bet has been paid' do
        let!(:payment) { create(:paid_payment, bet: bet) }
        it 'finds and assigns the payment' do
          get :new
          expect(assigns(:_payment)).to eql(payment)
          expect(assigns(:payment)).to be_instance_of(PaymentPresenter)
        end
      end
    end
  end

  # POST /bet/payment
  # Via: bet_payment_path
  describe '#create' do
    context 'when logged in' do
      let(:bet) { create(:bet) }
      let(:user) { bet.user }
      before(:each) { login_user(user) }
      context 'when the bet has not been paid' do
      end
      context 'when the bet is being paid' do
        let!(:payment) { create(:unpaid_payment, bet: bet) }
      end
      context 'when the bet has been paid' do
        let!(:payment) { create(:paid_payment, bet: bet) }
      end
    end
  end

  # POST /payment_notifications
  # Via: payment_notifications_path
  describe '#update' do
    context 'when logged in' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      it 'redirects with an error message' do
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
