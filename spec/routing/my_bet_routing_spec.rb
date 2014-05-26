require 'spec_helper'

describe BetsController do

  describe '#show' do
    it { expect(get('/my_bet')).to route_to(controller: 'my_bet', action: 'show') }
    it { expect(my_bet_path).to eq('/my_bet') }
  end

  describe '#matches' do
    it { expect(get('/my_bet/matches')).to route_to(controller: 'my_bet', action: 'matches') }
    it { expect(my_bet_matches_path).to eq('/my_bet/matches') }
  end

  describe '#questions' do
    it { expect(get('/my_bet/questions')).to route_to(controller: 'my_bet', action: 'questions') }
    it { expect(my_bet_questions_path).to eq('/my_bet/questions') }
  end

end
