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
      let(:bet) { create(:bet) }
      let(:user) { bet.user }
      let(:match) { create(:match) }
      before(:each) { login_user(user) }
      context 'when match is available to betting' do
        it 'should change the match_bet' do
          Timecop.freeze(match.bettable_until - 1.minute) do
            expect(match).to_not be_locked
            expect(match.match_bets.count).to eql(0)

            post :create, {match_id: match.id, match_bet: {goals_a: 1, goals_b: 3}}
            expect(response).to be_redirect
            expect(flash[:success]).to_not be_blank

            expect(match.match_bets.count).to eql(1)
          end
        end
      end
      context 'when match is locked' do
        it 'should not change the match_bet' do
          Timecop.freeze(match.bettable_until + 1.minute) do
            expect(match).to be_locked
            expect(match.match_bets.count).to eql(0)

            post :create, {match_id: match.id, match_bet: {goals_a: 1, goals_b: 3}}
            expect(response).to be_success
            expect(flash[:success]).to be_blank
            expect(response).to render_template('edit')

            expect(match.match_bets.count).to eql(0)
          end
        end
      end
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
      let(:bet) { create(:bet) }
      let(:user) { bet.user }
      let(:match) { create(:match) }
      let!(:match_bet) { create(:match_bet, bet: bet, match: match, goals_a: 2, goals_b: 0) }
      before(:each) { login_user(user) }
      context 'when match is available to betting' do
        it 'should change the match_bet' do
          Timecop.freeze(match.bettable_until - 1.minute) do
            expect(match).to_not be_locked
            expect(match_bet.goals_a).to eql(2)
            expect(match_bet.goals_b).to eql(0)

            put :update, {match_id: match.id, match_bet: {goals_a: 1, goals_b: 3}}
            expect(response).to be_redirect
            expect(flash[:success]).to_not be_blank

            match_bet.reload
            expect(match_bet.goals_a).to eql(1)
            expect(match_bet.goals_b).to eql(3)
          end
        end
      end
      context 'when match is locked' do
        it 'should not change the match_bet' do
          Timecop.freeze(match.bettable_until + 1.minute) do
            expect(match).to be_locked
            expect(match_bet.goals_a).to eql(2)
            expect(match_bet.goals_b).to eql(0)

            put :update, {match_id: match.id, match_bet: {goals_a: 1, goals_b: 3}}
            expect(response).to be_success
            expect(flash[:success]).to be_blank
            expect(response).to render_template('edit')

            match_bet.reload
            expect(match_bet.goals_a).to eql(2)
            expect(match_bet.goals_b).to eql(0)
          end
        end
      end
    end
  end

end
