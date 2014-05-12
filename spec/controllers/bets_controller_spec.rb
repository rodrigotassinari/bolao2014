require 'spec_helper'

describe BetsController do

  # GET /bet
  describe '#show' do
    context 'when not logged in' do
      it 'redirects to login' do
        get :show
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      it 'returns http success' do
        get :show
        expect(response).to be_success
      end
      it 'renders the correct template' do
        get :show
        expect(response).to render_template('show')
      end
    end
  end

end
