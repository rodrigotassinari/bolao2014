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

  describe '#next_question_to_bet' do
    let!(:question1) { create(:boolean_question, number: 1, body_pt: '1', body_en: '1', played_at: 2.days.ago) }
    let!(:question2) { create(:boolean_question, number: 2, body_pt: '2', body_en: '2', played_at: 1.day.ago) }
    let!(:question3) { create(:boolean_question, number: 3, body_pt: '3', body_en: '3', played_at: 1.day.from_now) }
    let!(:question4) { create(:boolean_question, number: 4, body_pt: '4', body_en: '4', played_at: 2.days.from_now) }
    let!(:question5) { create(:boolean_question, number: 5, body_pt: '5', body_en: '5', played_at: 3.days.from_now) }
    let!(:bet) { create(:bet) }
    let!(:question_bet2) { create(:boolean_question_bet, bet: bet, question: question2, answer: 'true') }
    let!(:question_bet3) { create(:boolean_question_bet, bet: bet, question: question3, answer: 'true') }
    let!(:new_question_bet1) { build(:boolean_question_bet, bet: bet, question: question4, answer: nil) }
    let!(:new_question_bet2) { build(:boolean_question_bet, bet: bet, question: question5, answer: nil) }
    before(:each) do
      expect(question1).to_not be_bettable
      expect(question2).to_not be_bettable
      expect(question3).to be_bettable
      expect(question4).to be_bettable
      expect(question5).to be_bettable
    end
    it "returns the next question who is bettable and has not been betted by the question_bet's bet" do
      expect(question_bet2.next_question_to_bet).to eql(question4)
      expect(question_bet3.next_question_to_bet).to eql(question4)
      expect(new_question_bet1.next_question_to_bet).to eql(question5)
      expect(new_question_bet2.next_question_to_bet).to eql(question4)
    end
    it "returns nil if there are no more bettable questiones by the question_bet's bet" do
      question4.destroy
      question5.destroy
      expect(question_bet2.next_question_to_bet).to be_nil
    end
  end

  describe '#scorable?' do
    let(:bet) { create(:bet) }
    let(:question) { create(:boolean_question) }
    subject { create(:boolean_question_bet, bet: bet, question: question) }
    it 'returns true if the question is scorable' do
      question.should_receive(:scorable?).and_return(true)
      expect(subject).to be_scorable
    end
    it 'returns false if the question is not scorable' do
      question.should_receive(:scorable?).and_return(false)
      expect(subject).to_not be_scorable
    end
    it 'returns false if not valid' do
      subject.answer = nil
      expect(subject).to_not be_scorable
    end
  end

  describe '#score!' do
    let(:bet) { create(:bet) }
    let(:question) { create(:boolean_question, answer: 'true', played_at: 1.day.ago) }
    subject { create(:boolean_question_bet, bet: bet, question: question) }
    it 'raises error if not scorable' do
      subject.should_receive(:scorable?).and_return(false)
      expect { subject.score! }.to raise_error(RuntimeError, 'question_bet is not scorable')
    end
    it 'sets / updates scored_at' do
      subject.stub(:scorable?).and_return(true)
      expect(subject.scored_at).to be_nil
      subject.score!
      subject.reload
      expect(subject.scored_at).to_not be_nil
      expect(subject.scored_at).to be_between(5.seconds.ago, 5.seconds.from_now)
    end
    it 'notifies user when if scoring changed the points'
    it 'does not notify user if scoring did not change the points'
    it 'sets / updates the bet points if points changed'
    it 'does not sets / updates the bet points if points did not change'
    context 'when answer is wrong' do
      subject { create(:boolean_question_bet, bet: bet, question: question, answer: 'false') }
      it 'scores 0 points' do
        expect(subject.points).to eql(0)
        subject.score!
        expect(subject.points).to eql(0)
      end
    end
    context 'when answer is correct' do
      subject { create(:boolean_question_bet, bet: bet, question: question, answer: 'true') }
      it 'scores full points' do
        expect(subject.points).to eql(0)
        subject.score!
        expect(subject.points).to eql(question.total_points)
      end
    end
  end

  describe '#scored?' do
    let(:bet) { create(:bet) }
    let(:question) { create(:boolean_question) }
    subject { create(:boolean_question_bet, bet: bet, question: question) }
    it 'returns true if has been scored' do
      subject.points = 10
      subject.scored_at = 1.hour.ago
      expect(subject).to be_scored
    end
    it 'returns false if has not been scored' do
      subject.points = 0
      subject.scored_at = nil
      expect(subject).to_not be_scored
    end
  end

end
