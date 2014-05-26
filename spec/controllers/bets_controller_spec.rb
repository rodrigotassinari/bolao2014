require 'spec_helper'

describe BetsController do

  describe "GET /bets" do
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
    end
  end

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
      let(:user) { build(:user, bet: build(:bet)) }
      let(:bet) { user.bet }
      before(:each) { login_user(user) }
      it 'returns http success' do
        get :show
        expect(response).to be_success
      end
      it 'renders the correct template' do
        get :show
        expect(response).to render_template('show')
      end
      it "assigns the logged user's bet, wrapped in a presenter" do
        get :show
        expect(assigns(:_bet)).to eql(bet)
        expect(assigns(:bet)).to be_an_instance_of(BetPresenter)
        expect(assigns(:bet).send(:subject)).to eql(bet)
      end
      it 'assigns all bettable matches not yet betted by the current user, in order, wrapped in presenter' do
        matches = [mock_model(Match)]
        matches_relation = double('matches_relation', all: matches)
        matches_presenters = [double(MatchPresenter)]
        bet.should_receive(:bettable_matches_still_to_bet).and_return(matches_relation)
        MatchPresenter.should_receive(:map).with(matches).and_return(matches_presenters)
        get :show
        expect(assigns(:_matches)).to eql(matches)
        expect(assigns(:matches)).to eql(matches_presenters)
      end
      it 'assigns all bettable matches not yet betted by the current user, in orderm wrapped in presenter' do
        questions = [mock_model(Question)]
        questions_relation = double('questions_relation', all: questions)
        questions_presenters = [double(QuestionPresenter)]
        bet.should_receive(:bettable_questions_still_to_bet).and_return(questions_relation)
        QuestionPresenter.should_receive(:map).with(questions).and_return(questions_presenters)
        get :show
        expect(assigns(:_questions)).to eql(questions)
        expect(assigns(:questions)).to eql(questions_presenters)
      end
    end
  end

end
