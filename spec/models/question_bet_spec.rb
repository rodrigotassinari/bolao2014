require 'spec_helper'

describe QuestionBet do

  context 'associations' do
    it { should belong_to(:bet) }
    it { should belong_to(:question) }
  end

  context 'validations' do
    it { should validate_presence_of(:bet) }
    it { should validate_presence_of(:question) }
    it { should validate_presence_of(:answer) }
    it { should validate_presence_of(:points) }
    it { should validate_numericality_of(:points).only_integer.is_greater_than_or_equal_to(0) }

    it 'only allows valid Team IDs as answer to Team type questions', locale: :pt do
      team = create(:team)
      question = create(:team_question)
      qb = build(:team_question_bet, question: question, answer: '42')

      expect(qb).to_not be_valid
      expect(qb.errors.get(:answer)).to eql(['não é válido'])

      qb.answer = team.id.to_s
      expect(qb).to be_valid
    end
    it 'only allows valid Player IDs as answer to Player type questions', locale: :pt do
      player = create(:field_player)
      question = create(:player_question)
      qb = build(:player_question_bet, question: question, answer: '42')

      expect(qb).to_not be_valid
      expect(qb.errors.get(:answer)).to eql(['não é válido'])

      qb.answer = player.id.to_s
      expect(qb).to be_valid
    end
    it 'only allows `true` or `false` as answer to boolean type questions', locale: :pt do
      question = create(:boolean_question)
      qb = build(:boolean_question_bet, question: question, answer: 'opa')

      expect(qb).to_not be_valid
      expect(qb.errors.get(:answer)).to eql(['não é válido'])

      qb.answer = 'true'
      expect(qb).to be_valid
    end
  end

  describe '#answer_object' do
    let(:team) { create(:team) }
    let(:player) { create(:field_player) }
    it 'returns nil without an answer set' do
      expect(subject.answer_object).to be_nil
    end
    context 'with team type question' do
      let(:question) { create(:team_question) }
      subject { build(:team_question_bet, question: question, answer: team.id.to_s) }
      it 'returns the Team object' do
        expect(subject.answer_object).to eql(team)
      end
    end
    context 'with player type question' do
      let(:question) { create(:player_question) }
      subject { build(:player_question_bet, question: question, answer: player.id.to_s) }
      it 'returns the Team object' do
        expect(subject.answer_object).to eql(player)
      end
    end
    context 'with boolean type question' do
      let(:question) { create(:boolean_question) }
      subject { build(:boolean_question_bet, question: question, answer: 'true') }
      it 'returns the Team object' do
        expect(subject.answer_object).to be_true
      end
    end
  end

  describe '#score!' do
    # TODO
  end

end
