require 'spec_helper'

describe BetsController do

  describe '#show' do
    it { expect(get('/bet')).to route_to(controller: 'bets', action: 'show') }
    it { expect(bet_path).to eq('/bet') }
  end

  describe '#matches' do
    it { expect(get('/bet/matches')).to route_to(controller: 'bets', action: 'matches') }
    it { expect(bet_matches_path).to eq('/bet/matches') }
  end

  describe '#questions' do
    it { expect(get('/bet/questions')).to route_to(controller: 'bets', action: 'questions') }
    it { expect(bet_questions_path).to eq('/bet/questions') }
  end

end
