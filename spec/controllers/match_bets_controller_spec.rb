require 'spec_helper'

describe MatchBetsController do

  describe '#edit' do
    context 'when not logged in' do
      it 'redirects to login' do
        get :edit, match_id: 42
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      # TODO
    end
  end

  describe '#create' do
    context 'when not logged in' do
      it 'redirects to login' do
        post :create, match_id: 42
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      # TODO
    end
  end

  describe '#update' do
    context 'when not logged in' do
      it 'redirects to login' do
        put :update, match_id: 42
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      # TODO
    end
  end

end
