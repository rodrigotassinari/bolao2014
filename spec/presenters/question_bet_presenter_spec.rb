require 'spec_helper'

describe QuestionBetPresenter do
  let(:bet) { build(:bet) }
  let(:question) { build(:boolean_question) }
  let(:question_bet) do
    build(:boolean_question_bet,
      id: 49,
      bet: bet,
      question: question,
      answer: 'true',
      points: 33,
      created_at: '2014-06-12 17:00:00 -0300'.to_time,
      updated_at: '2014-06-13 17:00:00 -0300'.to_time
    )
  end
  subject { described_class.new(question_bet) }

  its(:to_key) { should eql([49]) }
  its(:to_param) { should eql('49') }
  its(:answer) { should eql('true') }
  its(:answer_object) { should be_true }
  its(:points) { should eql(33) }
  its(:created_at) { should eql('2014-06-12 17:00:00 -0300'.to_time) }
  its(:updated_at) { should eql('2014-06-13 17:00:00 -0300'.to_time) }

  it 'wraps associated question in a presenter' do
    expect(subject.question).to be_an_instance_of(QuestionPresenter)
    expect(subject.question.send(:subject)).to eq(question)
  end

  it 'wraps associated bet in a presenter' do
    expect(subject.bet).to be_an_instance_of(BetPresenter)
    expect(subject.bet.send(:subject)).to eq(bet)
  end

end
