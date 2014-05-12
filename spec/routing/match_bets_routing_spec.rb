require 'spec_helper'

describe MatchBetsController do

  describe '#edit' do
    it { get('/bet/matches/42').should route_to(controller: 'match_bets', action: 'edit', match_id: '42') }
    it { expect(match_bet_path(42)).to eq('/bet/matches/42') }
  end

  describe '#create' do
    it { post('/bet/matches/42').should route_to(controller: 'match_bets', action: 'create', match_id: '42') }
  end

  describe '#update' do
    it { put('/bet/matches/42').should route_to(controller: 'match_bets', action: 'update', match_id: '42') }
  end

end
