require 'spec_helper'

describe BetsController do

  # GET /bets
  describe '#index' do
    let!(:user_1) { create(:user)}
    let!(:user_2) { create(:user, email: 'tapajos@gmail.com')}
    let!(:bet_1) { create(:bet, user: user_1, points: 10) }
    let!(:bet_2) { create(:bet, user: user_2, points: 20) }

    before(:each) { login_user(user_1) }

    it "assigns bets sorted by score" do
      get :index
      expect(response).to be_success
      expect(assigns(:bets).first.points).to eql(bet_2.points)
      expect(assigns(:bets).last.points).to eql(bet_1.points)
      expect(assigns(:paid_bets_count)).to eql(0)
      expect(assigns(:paying_bets_count)).to eql(0)
    end
  end

  # GET /bets/:id
  describe '#show' do
    context 'when not logged in' do
      it 'redirects to login' do
        get :show, id: 42
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in' do
      # TODO
    end
  end

end
