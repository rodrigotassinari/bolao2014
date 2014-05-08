require 'spec_helper'

describe SessionsController do

  describe 'GET new' do
    it 'returns http success' do
      get :new
      expect(response).to be_success
    end
    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'POST one_time_token' do
    context 'when user supplies a valid email' do
      let(:params) { {email: 'someone@example.com'} }
      it 'returns http success' do
        post :one_time_token, params
        expect(response).to be_success
      end
      it 'renders the one_time_token template' do
        post :one_time_token, params
        expect(response).to render_template('one_time_token')
      end
      it 'assigns the email variable' do
        post :one_time_token, params
        expect(assigns[:email]).to eq('someone@example.com')
      end
    end
    context 'when user supplies an invalid email' do
      let(:params) { {email: 'invalid email'} }
      it 'redirects to the login page' do
        post :one_time_token, params
        expect(response).to_not be_success
        expect(response).to redirect_to(login_path)
      end
      it 'sets a flash error message' do
        post :one_time_token, params
        expect(flash[:error]).to eql(I18n.t('sessions.one_time_token.flash.email_invalid_error'))
      end
    end
    context 'when no email is given' do
      let(:params) { {email: ''} }
      it 'redirects to the login page' do
        post :one_time_token, params
        expect(response).to_not be_success
        expect(response).to redirect_to(login_path)
      end
      it 'sets a flash error message' do
        post :one_time_token, params
        expect(flash[:error]).to eql(I18n.t('sessions.one_time_token.flash.email_required_error'))
      end
    end
  end

  describe 'POST create' do
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
