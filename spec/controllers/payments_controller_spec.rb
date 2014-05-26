require 'spec_helper'

describe PaymentsController do

  # GET /bet/payment
  # Via: my_bet_payment_path
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
  # Via: my_bet_payment_path
  describe '#create' do
    context 'when logged in' do
      let(:bet) { create(:bet) }
      let(:user) { bet.user }
      before(:each) { login_user(user) }
      context 'when the bet has not been paid' do
        let(:payment) { build(:initiated_payment, bet: bet) }
        before(:each) do
          Payment.should_receive(:find_or_initialize_with_defaults).with(bet).and_return(payment)
        end
        context 'on success' do
          before(:each) do
            payment.should_receive(:request_and_save!).and_return(true)
            payment.should_receive(:checkout_url).and_return('http://go.to/payment')
          end
          it 'creates a payment and redirects to the payment gateway' do
            post :create
            expect(response).to redirect_to('http://go.to/payment')
          end
        end
        context 'on failure' do
          before(:each) do
            payment.should_receive(:request_and_save!).and_return(false)
          end
          it 'redirects with an error', locale: :pt do # error with payment gateway
            post :create
            expect(response).to redirect_to(my_bet_payment_path)
            expect(flash[:error]).to eql('Não foi possível iniciar seu pagamento, tente novamente em breve ou entre em contato caso o erro continue.')
          end
        end
      end
      context 'when the bet is being paid' do
        let!(:payment) { create(:unpaid_payment, bet: bet) }
        it 'redirects with an error', locale: :pt do # in normal use should never get here in this state
          post :create
          expect(response).to redirect_to(my_bet_payment_path)
          expect(flash[:error]).to eql('Houve um erro interno ao iniciar seu pagamento, por favor entre em contato.')
        end
      end
      context 'when the bet has been paid' do
        let!(:payment) { create(:paid_payment, bet: bet) }
        it 'redirects with an error', locale: :pt do # in normal use should never get here in this state
          post :create
          expect(response).to redirect_to(my_bet_payment_path)
          expect(flash[:error]).to eql('Houve um erro interno ao iniciar seu pagamento, por favor entre em contato.')
        end
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
