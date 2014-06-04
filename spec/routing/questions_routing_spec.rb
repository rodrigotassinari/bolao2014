require 'spec_helper'

describe QuestionsController do

  describe '#index' do
    it { expect(get('/questions')).to route_to(controller: 'questions', action: 'index') }
    it { expect(questions_path).to eq('/questions') }
  end

  describe '#show' do
    it { expect(get('/questions/42')).to route_to(controller: 'questions', action: 'show', id: '42') }
    it { expect(question_path(42)).to eq('/questions/42') }
  end

end
