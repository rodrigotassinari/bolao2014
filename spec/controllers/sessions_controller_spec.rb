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
        it 'assigns the user with errors', locale: :en do
          user = assigns(:user)
          expect(user).to be_present
          expect(user.errors.any?).to be_true
          expect(user.errors.get(:email)).to eq(["can't be blank"])
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
      context 'with matching email and authentication_token' do
        # TODO
      end
      context 'with invalid email or authentication_token' do
        # TODO
      end
      context 'with missing authentication_token' do
        # TODO
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
      # TODO
    end
  end

end
