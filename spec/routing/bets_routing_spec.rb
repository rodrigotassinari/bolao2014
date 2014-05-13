require 'spec_helper'

describe BetsController do

  describe '#show' do
    it { get('/bet').should route_to(controller: 'bets', action: 'show') }
    it { expect(bet_path).to eq('/bet') }
  end

  describe '#matches' do
    it { get('/bet/matches').should route_to(controller: 'bets', action: 'matches') }
    it { expect(bet_matches_path).to eq('/bet/matches') }
  end

  describe '#questions' do
    it { get('/bet/questions').should route_to(controller: 'bets', action: 'questions') }
    it { expect(bet_questions_path).to eq('/bet/questions') }
  end

end
