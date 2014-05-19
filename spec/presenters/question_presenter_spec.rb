require 'spec_helper'

describe QuestionPresenter do
  let(:question) do
    build(:boolean_question,
      id: 49,
      number: 12,
      body_en: 'Who are you?',
      body_pt: 'Quem é você?',
      played_at: '2014-06-12 17:00:00 -0300'.to_time,
      answer_type: 'boolean',
      answer: 'true'
    )
  end
  subject { described_class.new(question) }

  its(:to_key) { should eql([49]) }
  its(:to_param) { should eql('49') }
  its(:number) { should eql(12) }
  its(:body_en) { should eql('Who are you?') }
  its(:body_pt) { should eql('Quem é você?') }
  its(:body) { should eql('Quem é você?') } # locale: :pt
  its(:played_at) { should eql('2014-06-12 17:00:00 -0300'.to_time) }
  its(:answer_type) { should eql('boolean') }
  its(:answer) { should eql('true') }

  describe '#answer_object' do
    context 'when team question' do
      let(:team) { create(:team) }
      let(:question) { build(:team_question, answer: team.id.to_s) }
      it 'wraps associated team in a presenter' do
        expect(subject.answer_object).to be_an_instance_of(TeamPresenter)
        expect(subject.answer_object.send(:subject)).to eq(team)
      end
    end
    context 'when player question' do
      let(:player) { create(:goal_player) }
      let(:question) { build(:player_question, answer: player.id.to_s) }
      it 'wraps associated player in a presenter' do
        expect(subject.answer_object).to be_an_instance_of(PlayerPresenter)
        expect(subject.answer_object.send(:subject)).to eq(player)
      end
    end
    context 'when boolean question' do
      it 'returns a boolean' do
        expect(subject.answer_object).to be_an_instance_of(TrueClass)
        expect(subject.answer_object).to be_true
      end
    end
  end


end
