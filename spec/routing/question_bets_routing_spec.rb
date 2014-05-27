require 'spec_helper'

describe QuestionBetsController do

  describe '#edit' do
    it { expect(get('/my_bet/questions/42')).to route_to(controller: 'question_bets', action: 'edit', question_id: '42') }
    it { expect(my_question_bet_path(42)).to eq('/my_bet/questions/42') }
  end

  describe '#create' do
    it { expect(post('/my_bet/questions/42')).to route_to(controller: 'question_bets', action: 'create', question_id: '42') }
  end

  describe '#update' do
    it { expect(put('/my_bet/questions/42')).to route_to(controller: 'question_bets', action: 'update', question_id: '42') }
  end

end
