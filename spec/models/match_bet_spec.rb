require 'spec_helper'

describe MatchBet do

  context 'associations' do
    it { should belong_to(:bet) }
    it { should belong_to(:match) }
  end

  context 'validations' do
    it { should validate_presence_of(:bet) }
    it { should validate_presence_of(:match) }
    it { should validate_presence_of(:points) }
    it { should validate_numericality_of(:points).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:goals_a) }
    it { should validate_numericality_of(:goals_a).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:goals_b) }
    it { should validate_numericality_of(:goals_b).only_integer.is_greater_than_or_equal_to(0) }

    it 'allows match_bet to be a draw during groups phase' do
      match = create(:match, round: 'group')
      mb = build(:match_bet, match: match, goals_a: 1, goals_b: 1)
      expect(mb).to be_valid
    end
    it 'does not allow match_bet to be a draw after groups phase', locale: :pt do
      match = create(:match, round: 'round_16')
      mb = build(:match_bet, match: match, goals_a: 1, goals_b: 1)
      expect(mb).to_not be_valid
      expect(mb.errors.get(:penalty_winner_id)).to eq(['não pode ficar em branco'])
    end
    it 'allows match_bet to be a normal win after groups phase' do
      match = create(:match, round: 'round_16')
      mb = build(:match_bet, match: match, goals_a: 2, goals_b: 1)
      expect(mb).to be_valid
    end
    it 'does not allow match to have a penalty_winner during group phase', locale: :pt do
      match = create(:match, round: 'group')
      mb = build(:match_bet, match: match, goals_a: 1, goals_b: 1, penalty_winner_id: match.team_a_id)
      expect(mb).to_not be_valid
      expect(mb.errors.get(:penalty_winner_id)).to eq(['deve ficar em branco'])
    end
    it 'does not allow match to have a penalty_winner after group phase if it is not a draw', locale: :pt do
      match = create(:match, round: 'round_16')
      mb = build(:match_bet, match: match, goals_a: 2, goals_b: 1, penalty_winner_id: match.team_a_id)
      expect(mb).to_not be_valid
      expect(mb.errors.get(:penalty_winner_id)).to eq(['deve ficar em branco'])
    end
  end

  describe '#next_match_to_bet' do
    let!(:team_a) { create(:team) }
    let!(:team_b) { create(:other_team) }
    let!(:match1) { create(:match, number: 1, team_a: team_a, team_b: team_b, played_at: 2.days.ago) }
    let!(:match2) { create(:match, number: 2, team_a: team_a, team_b: team_b, played_at: 1.day.ago) }
    let!(:match3) { create(:match, number: 3, team_a: team_a, team_b: team_b, played_at: 1.day.from_now) }
    let!(:match4) { create(:match, number: 4, team_a: team_a, team_b: team_b, played_at: 2.days.from_now) }
    let!(:match5) { create(:match, number: 5, team_a: team_a, team_b: team_b, played_at: 3.days.from_now) }
    let!(:bet) { create(:bet) }
    let!(:match_bet2) { create(:match_bet, bet: bet, match: match2, goals_a: 1, goals_b: 0) }
    let!(:match_bet3) { create(:match_bet, bet: bet, match: match3, goals_a: 1, goals_b: 0) }
    let!(:new_match_bet1) { build(:match_bet, bet: bet, match: match4, goals_a: nil, goals_b: nil) }
    let!(:new_match_bet2) { build(:match_bet, bet: bet, match: match5, goals_a: nil, goals_b: nil) }
    before(:each) do
      expect(match1).to_not be_bettable
      expect(match2).to_not be_bettable
      expect(match3).to be_bettable
      expect(match4).to be_bettable
      expect(match5).to be_bettable
    end
    it "returns the next match who is bettable and has not been betted by the match_bet's bet" do
      expect(match_bet2.next_match_to_bet).to eql(match4)
      expect(match_bet3.next_match_to_bet).to eql(match4)
      expect(new_match_bet1.next_match_to_bet).to eql(match5)
      expect(new_match_bet2.next_match_to_bet).to eql(match4)
    end
    it "returns nil if there are no more bettable matches by the match_bet's bet" do
      match4.destroy
      match5.destroy
      expect(match_bet2.next_match_to_bet).to be_nil
    end
  end

  describe '#scorable?' do
    let(:bet) { create(:bet) }
    let(:match) { create(:match) }
    subject { create(:match_bet, bet: bet, match: match) }
    it 'returns true if the match is scorable' do
      match.should_receive(:scorable?).and_return(true)
      expect(subject).to be_scorable
    end
    it 'returns false if the match is not scorable' do
      match.should_receive(:scorable?).and_return(false)
      expect(subject).to_not be_scorable
    end
    it 'returns false if not valid' do
      subject.goals_a = nil
      expect(subject).to_not be_scorable
    end
  end

  describe '#result' do
    let(:bet) { create(:bet) }
    let(:team_a) { create(:team) }
    let(:team_b) { create(:other_team) }
    let(:group_match) { create(:match, played_at: 1.day.ago, goals_a: 1, goals_b: 0, team_a: team_a, team_b: team_b) }
    let(:final_match) { create(:match, played_at: 1.day.ago, goals_a: 1, goals_b: 0, team_a: team_a, team_b: team_b, round: 'round_16') }
    it 'returns nil if not valid' do
      match_bet = build(:match_bet, bet: bet, match: group_match, goals_a: nil)
      expect(match_bet).to_not be_valid
      expect(match_bet.result).to be_nil
    end
    it 'returns team_a as winner' do
      match_bet = build(:match_bet, bet: bet, match: group_match, goals_a: 1, goals_b: 0)
      expect(match_bet.result).to eql(:team_a)
    end
    it 'returns team_b as winner' do
      match_bet = build(:match_bet, bet: bet, match: group_match, goals_a: 0, goals_b: 1)
      expect(match_bet.result).to eql(:team_b)
    end
    it 'returns no one as winner (draw)' do
      match_bet = build(:match_bet, bet: bet, match: group_match, goals_a: 0, goals_b: 0)
      expect(match_bet.result).to eql(:draw)
    end
    it 'returns team_a as winner by penaltys' do
      match_bet = build(:match_bet, bet: bet, match: final_match, goals_a: 1, goals_b: 1, penalty_winner_id: team_a.id)
      expect(match_bet.result).to eql(:team_a)
    end
    it 'returns team_b as winner by penaltys' do
      match_bet = build(:match_bet, bet: bet, match: final_match, goals_a: 1, goals_b: 1, penalty_winner_id: team_b.id)
      expect(match_bet.result).to eql(:team_b)
    end
  end

end
