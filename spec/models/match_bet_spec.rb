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

end
