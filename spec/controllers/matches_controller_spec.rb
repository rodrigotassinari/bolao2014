require 'spec_helper'

describe MatchesController do

  describe '#index' do
    context 'when not logged in' do
      it 'redirects to login' do
        get :index
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      it 'returns http success' do
        get :index
        expect(response).to be_success
      end
      it 'renders the correct template' do
        get :index
        expect(response).to render_template('index')
      end
      it 'assigns all matches, in order, wrapped in presenter' do
        matches = [mock_model(Match)]
        Match.should_receive(:all_in_order).and_return(matches)
        get :index
        expect(assigns(:matches)).to eql(matches)
      end
    end
  end

  describe '#show' do
    context 'when not logged in' do
      it 'redirects to login' do
        get :show, id: 42
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in' do
      let(:user) { build(:user) }
      let(:match) { create(:match) }
      before(:each) { login_user(user) }
      it 'returns http success' do
        get :show, id: match.id
        expect(response).to be_success
      end
      it 'renders the correct template' do
        get :show, id: match.id
        expect(response).to render_template('show')
      end
      it 'assigns all matches, in order' do
        get :show, id: match.id
        expect(assigns(:match)).to eql(match)
      end
    end
  end

end
