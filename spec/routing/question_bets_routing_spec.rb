require 'spec_helper'

describe QuestionBetsController do

  describe '#edit' do
    it { get('/bet/questions/42').should route_to(controller: 'question_bets', action: 'edit', question_id: '42') }
    it { expect(question_bet_path(42)).to eq('/bet/questions/42') }
  end

  describe '#create' do
    it { post('/bet/questions/42').should route_to(controller: 'question_bets', action: 'create', question_id: '42') }
  end

  describe '#update' do
    it { put('/bet/questions/42').should route_to(controller: 'question_bets', action: 'update', question_id: '42') }
  end

end
