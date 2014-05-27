require 'spec_helper'

describe SessionsController do

  # GET /login
  describe '#new' do
    context 'when logged in' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      it 'redirects to root' do
        get :new
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when not logged in' do
      it 'returns http success' do
        get :new
        expect(response).to be_success
      end
      it 'assigns a new blank user' do
        get :new
        user = assigns(:user)
        expect(user).to be_present
        expect(user).to be_new_record
        expect(user.errors.any?).to be_false
      end
      it 'renders the new template' do
        get :new
        expect(response).to render_template('new')
      end
    end
  end

  # POST /one_time_token
  describe '#one_time_token' do
    context 'when logged in' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      it 'redirects to root' do
        post :one_time_token
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when not logged in' do
      context 'when user supplies a valid email' do
        let(:params) { {email: 'someone@example.com'} }
        before(:each) do
          post :one_time_token, params
        end
        it 'returns http success' do
          expect(response).to be_success
        end
        it 'renders the one_time_token template' do
          expect(response).to render_template('one_time_token')
        end
        it 'assigns the user' do
          user = assigns(:user)
          expect(user).to be_present
          expect(user.email).to eq('someone@example.com')
          expect(user.errors.any?).to be_false
        end
        it 'assigns remember_me' do
          expect(assigns(:remember_me)).to be_true
        end
      end
      context 'when user supplies a valid but upcased email' do
        let(:params) { {email: 'Someone@eXample.Com'} }
        before(:each) do
          post :one_time_token, params
        end
        it 'assigns the user (with downcased email)' do
          user = assigns(:user)
          expect(user).to be_present
          expect(user.email).to eq('someone@example.com')
          expect(user.errors.any?).to be_false
        end
      end
      context 'when user supplies an invalid email' do
        let(:params) { {email: 'invalid email'} }
        before(:each) do
          post :one_time_token, params
        end
        it 'returns http success' do
          expect(response).to be_success
        end
        it 'renders the new template' do
          expect(response).to render_template('new')
        end
        it 'assigns the user with errors', locale: :pt do
          user = assigns(:user)
          expect(user).to be_present
          expect(user.errors.any?).to be_true
          expect(user.errors.get(:email)).to eq(['não é válido'])
        end
      end
      context 'when no email is given' do
        let(:params) { {email: ''} }
        before(:each) do
          post :one_time_token, params
        end
        it 'returns http success' do
          expect(response).to be_success
        end
        it 'renders the new template' do
          expect(response).to render_template('new')
        end
        it 'assigns the user with errors', locale: :pt do
          user = assigns(:user)
          expect(user).to be_present
          expect(user.errors.any?).to be_true
          expect(user.errors.get(:email)).to eq(['não pode ficar em branco'])
        end
      end
    end
  end

  # POST /login
  describe '#create' do
    context 'when logged in' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      it 'redirects to root' do
        post :create
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when not logged in' do
      let(:user) { create(:user) }
      before(:each) do
        expect(user.remember_me_token).to_not be_blank
        @password = user.generate_authentication_token!
      end
      context 'with matching email and authentication_token' do
        let(:params) { {email: user.email, password: @password} }
        it 'logs in the user' do
          expect(cookies.signed[:remember_me_token]).to be_blank
          post :create, params
          expect(cookies.signed[:remember_me_token]).to eq(user.remember_me_token)
          expect(controller.send(:current_user)).to eq(user)
        end
        it 'remembers the login via permanent cookie if requested' do
          expect(cookies.permanent.signed[:remember_me_token]).to be_blank
          post :create, params.merge(remember_me: 'true')
          expect(cookies.permanent.signed[:remember_me_token]).to eq(user.remember_me_token)
          expect(controller.send(:current_user)).to eq(user)
        end
        it 'redirects to the bet page with a success message' do
          post :create, params
          expect(response).to redirect_to(my_bet_path)
          expect(flash[:success]).to eq(I18n.t('sessions.create.flash.authentication_success'))
        end
      end
      context 'with invalid email' do
        let(:params) { {email: 'wrong email', password: @password} }
        it 'redirects back to the login page with an error message' do
          post :create, params
          expect(response).to redirect_to(login_path)
          expect(flash[:error]).to eq(I18n.t('sessions.create.flash.authentication_failed'))
        end
        it 'does not login the user and resets the session' do
          expect(cookies.signed[:remember_me_token]).to be_blank
          post :create, params
          expect(cookies.signed[:remember_me_token]).to be_blank
        end
      end
      context 'with invalid authentication_token' do
        let(:params) { {email: user.email, password: 'wrong password'} }
        it 'redirects back to the login page with an error message' do
          post :create, params
          expect(response).to redirect_to(login_path)
          expect(flash[:error]).to eq(I18n.t('sessions.create.flash.authentication_failed'))
        end
        it 'does not login the user and resets the session' do
          expect(cookies.signed[:remember_me_token]).to be_blank
          post :create, params
          expect(cookies.signed[:remember_me_token]).to be_blank
        end
        it 'invalidates the authentication_token' do
          expect(user.authentication_token).to_not be_blank
          expect(user.authentication_token_expires_at).to_not be_blank
          post :create, params
          user.reload
          expect(user.authentication_token).to be_blank
          expect(user.authentication_token_expires_at).to be_blank
        end
      end
      context 'with missing authentication_token' do
        let(:params) { {email: user.email} }
        it 'redirects back to the login page with an error message' do
          post :create, params
          expect(response).to redirect_to(login_path)
          expect(flash[:error]).to eq(I18n.t('sessions.create.flash.authentication_failed'))
        end
        it 'does not login the user and resets the session' do
          expect(cookies.signed[:remember_me_token]).to be_blank
          post :create, params
          expect(cookies.signed[:remember_me_token]).to be_blank
        end
        it 'invalidates the authentication_token' do
          expect(user.authentication_token).to_not be_blank
          expect(user.authentication_token_expires_at).to_not be_blank
          post :create, params
          user.reload
          expect(user.authentication_token).to be_blank
          expect(user.authentication_token_expires_at).to be_blank
        end
      end
    end
  end

  # GET /logout
  describe '#destroy' do
    context 'when not logged in' do
      it 'redirects to login' do
        get :destroy
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      it 'destroys the session' do
        controller.should_receive(:reset_session)
        get :destroy
      end
      it 'erases the cookies' do
        get :destroy
        expect(cookies.signed[:remember_me_token]).to be_blank
        expect(cookies.permanent.signed[:remember_me_token]).to be_blank
      end
      it 'redirects to the root page with a message' do
        get :destroy
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq(I18n.t('sessions.destroy.flash.logged_out'))
      end
    end
  end

end
