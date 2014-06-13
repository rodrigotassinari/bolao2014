require 'spec_helper'

describe Bet do

  context 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:match_bets) }
    it { should have_many(:question_bets) }
    it { should have_many(:matches).through(:match_bets) }
    it { should have_many(:questions).through(:question_bets) }
    it { should have_one(:payment) }
  end

  context 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:points) }
    it { should validate_numericality_of(:points).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe '#bettable_matches' do
    subject { build(:bet) }
    let!(:bettable_match) { create(:match) }
    let!(:now) { bettable_match.played_at - 6.hours }
    let!(:unbettable_match1) { create(:match, number: 2, team_a: Team.first, team_b: Team.last, played_at: (now + 5.minutes)) }
    let!(:unbettable_match2) { create(:future_match, played_at: (now + 15.minutes)) }
    before(:each) do
      Timecop.freeze(now) do
        expect(bettable_match).to be_bettable
        expect(unbettable_match1).to_not be_bettable
        expect(unbettable_match2).to_not be_bettable
      end
    end
    it 'returns all bettable matches' do
      Timecop.freeze(now) do
        expect(subject.bettable_matches.all).to eq([bettable_match])
      end
    end
  end

  describe '#bettable_matches_still_to_bet' do
    subject! { create(:bet) }
    let!(:bettable_match1) { create(:match) }
    let!(:now) { bettable_match1.played_at - 6.hours }
    let!(:bettable_match2) { create(:match, number: 2, team_a: Team.first, team_b: Team.last) }
    let!(:unbettable_match1) { create(:match, number: 3, team_a: Team.first, team_b: Team.last, played_at: (now + 5.minutes)) }
    let!(:unbettable_match2) { create(:future_match, played_at: (now + 15.minutes)) }
    let!(:match_bet_1) { create(:match_bet, bet: subject, match: bettable_match1) }
    before(:each) do
      Timecop.freeze(now) do
        expect(bettable_match1).to be_bettable
        expect(bettable_match2).to be_bettable
        expect(unbettable_match1).to_not be_bettable
        expect(unbettable_match2).to_not be_bettable
      end
    end
    it 'returns all bettable matches still to be betted by this bet' do
      Timecop.freeze(now) do
        expect(subject.bettable_matches_still_to_bet.all).to eq([bettable_match2])
      end
    end
  end

  describe '#bettable_matches_already_betted' do
    subject! { create(:bet) }
    let!(:bettable_match1) { create(:match) }
    let!(:now) { bettable_match1.played_at - 6.hours }
    let!(:bettable_match2) { create(:match, number: 2, team_a: Team.first, team_b: Team.last) }
    let!(:unbettable_match1) { create(:match, number: 3, team_a: Team.first, team_b: Team.last, played_at: (now + 5.minutes)) }
    let!(:unbettable_match2) { create(:future_match, played_at: (now + 15.minutes)) }
    let!(:match_bet_1) { create(:match_bet, bet: subject, match: bettable_match1) }
    before(:each) do
      Timecop.freeze(now) do
        expect(bettable_match1).to be_bettable
        expect(bettable_match2).to be_bettable
        expect(unbettable_match1).to_not be_bettable
        expect(unbettable_match2).to_not be_bettable
      end
    end
    it 'returns all bettable matches still to be betted by this bet' do
      Timecop.freeze(now) do
        expect(subject.bettable_matches_already_betted.all).to eq([bettable_match1])
      end
    end
  end

  describe '#bettable_questions' do
    subject { build(:bet) }
    let!(:bettable_question) { create(:boolean_question) }
    let!(:now) { bettable_question.played_at - 6.hours }
    let!(:unbettable_question) { create(:team_question, played_at: (now + 5.minutes)) }
    before(:each) do
      Timecop.freeze(now) do
        expect(bettable_question).to be_bettable
        expect(unbettable_question).to_not be_bettable
      end
    end
    it 'returns all bettable questions' do
      Timecop.freeze(now) do
        expect(subject.bettable_questions.all).to eq([bettable_question])
      end
    end
  end

  describe '#bettable_questions_still_to_bet' do
    subject! { create(:bet) }
    let!(:bettable_question1) { create(:boolean_question) }
    let!(:now) { bettable_question1.played_at - 6.hours }
    let!(:bettable_question2) { create(:player_question) }
    let!(:unbettable_question) { create(:team_question, played_at: (now + 5.minutes)) }
    let!(:question_bet_1) { create(:boolean_question_bet, bet: subject, question: bettable_question1) }
    before(:each) do
      Timecop.freeze(now) do
        expect(bettable_question1).to be_bettable
        expect(bettable_question2).to be_bettable
        expect(unbettable_question).to_not be_bettable
      end
    end
    it 'returns all bettable questions still to be betted by this bet' do
      Timecop.freeze(now) do
        expect(subject.bettable_questions_still_to_bet.all).to eq([bettable_question2])
      end
    end
  end

  describe '#bettable_questions_already_betted' do
    subject! { create(:bet) }
    let!(:bettable_question1) { create(:boolean_question) }
    let!(:now) { bettable_question1.played_at - 6.hours }
    let!(:bettable_question2) { create(:player_question) }
    let!(:unbettable_question) { create(:team_question, played_at: (now + 5.minutes)) }
    let!(:question_bet_1) { create(:boolean_question_bet, bet: subject, question: bettable_question1) }
    before(:each) do
      Timecop.freeze(now) do
        expect(bettable_question1).to be_bettable
        expect(bettable_question2).to be_bettable
        expect(unbettable_question).to_not be_bettable
      end
    end
    it 'returns all bettable questions still to be betted by this bet' do
      Timecop.freeze(now) do
        expect(subject.bettable_questions_already_betted.all).to eq([bettable_question1])
      end
    end
  end

end
