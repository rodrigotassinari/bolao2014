require 'spec_helper'

describe MatchBetsController do

  describe '#edit' do
    it { expect(get('/my_bet/matches/42')).to route_to(controller: 'match_bets', action: 'edit', match_id: '42') }
    it { expect(my_match_bet_path(42)).to eq('/my_bet/matches/42') }
  end

  describe '#create' do
    it { expect(post('/my_bet/matches/42')).to route_to(controller: 'match_bets', action: 'create', match_id: '42') }
  end

  describe '#update' do
    it { expect(put('/my_bet/matches/42')).to route_to(controller: 'match_bets', action: 'update', match_id: '42') }
  end

end
