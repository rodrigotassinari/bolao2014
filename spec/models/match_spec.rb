require 'spec_helper'

describe Match do

  context 'associations' do
    it { should belong_to(:team_a).class_name('Team') }
    it { should belong_to(:team_b).class_name('Team') }
    it { should have_many(:match_bets) }
  end

  context 'validations' do
    it { should validate_presence_of(:number) }
    it { should validate_uniqueness_of(:number) }

    it { should validate_presence_of(:round) }
    it { should ensure_inclusion_of(:round).in_array(Match::ROUNDS) }

    it { should ensure_inclusion_of(:group).in_array(Match::GROUPS) }

    it { should validate_presence_of(:played_at) }

    it { should validate_presence_of(:played_on) }
    it { should ensure_inclusion_of(:played_on).in_array(Match::VENUES.keys) }

    it { should validate_numericality_of(:goals_a).only_integer.is_greater_than_or_equal_to(0) }

    it { should validate_numericality_of(:goals_b).only_integer.is_greater_than_or_equal_to(0) }

    it { should validate_numericality_of(:penalty_goals_a).only_integer.is_greater_than_or_equal_to(0) }

    it { should validate_numericality_of(:penalty_goals_b).only_integer.is_greater_than_or_equal_to(0) }

    it 'ensures both teams are not the same', locale: :pt do
      team = create(:team)

      match = Match.new(team_a_id: team.id, team_b_id: team.id)
      expect(match).to_not be_valid
      expect(match.errors.get(:team_b_id)).to eq(['não pode ser o mesmo que o outro'])

      match = build(:match, team_a: team, team_b: team)
      expect(match).to_not be_valid
      expect(match.errors.get(:team_b_id)).to eq(['não pode ser o mesmo que o outro'])
    end

    it 'ensures both teams are from the same group as the match', locale: :pt do
      team1 = create(:team, group: 'A')
      team2 = create(:other_team, group: 'B')

      match = Match.new(group: 'A', team_a_id: team1.id, team_b_id: team2.id)
      expect(match).to_not be_valid
      expect(match.errors.get(:group)).to eq(['não é o mesmo dos times'])

      match = build(:match, group: 'C', team_a: team1, team_b: team2)
      expect(match).to_not be_valid
      expect(match.errors.get(:group)).to eq(['não é o mesmo dos times'])

      match = build(:match, group: nil, team_a: team1, team_b: team2)
      expect(match).to be_valid
    end

    it 'allows draws on group phase' do
      team1 = create(:team)
      team2 = create(:other_team)
      match = build(:match, team_a: team1, team_b: team2, round: 'group', goals_a: 0, goals_b: 0)
      expect(match).to be_valid
    end
    it 'ensures no draws after group phase', locale: :pt do
      team1 = create(:team)
      team2 = create(:other_team)
      match = build(:match, team_a: team1, team_b: team2, round: 'round_16', goals_a: 0, goals_b: 0)
      expect(match).to_not be_valid
      expect(match.errors.get(:penalty_goals_a)).to eq(['não pode ficar em branco'])
      expect(match.errors.get(:penalty_goals_b)).to eq(['não pode ficar em branco'])

      match = build(:match, team_a: team1, team_b: team2, round: 'round_16', goals_a: 0, goals_b: 0, penalty_goals_a: 1, penalty_goals_b: 1)
      expect(match).to_not be_valid
      expect(match.errors.get(:penalty_goals_a)).to be_nil
      expect(match.errors.get(:penalty_goals_b)).to eq(['não pode ser o mesmo que o outro'])

      match = build(:match, team_a: team1, team_b: team2, round: 'round_16', goals_a: 0, goals_b: 0, penalty_goals_a: 2, penalty_goals_b: 1)
      expect(match).to be_valid
    end

    it 'ensures no penalty_goals during group phase', locale: :pt do
      team1 = create(:team)
      team2 = create(:other_team)
      match = build(:match, team_a: team1, team_b: team2, round: 'group', goals_a: 0, goals_b: 0)
      expect(match).to be_valid
      match.penalty_goals_a = 2
      match.penalty_goals_b = 1
      expect(match).to_not be_valid
      expect(match.errors.get(:penalty_goals_a)).to eq(['deve ficar em branco'])
      expect(match.errors.get(:penalty_goals_b)).to eq(['deve ficar em branco'])
    end
  end

  describe '#locked?' do
    let(:match) { build(:match) }
    let(:limit) { described_class.hours_before_start_time_to_bet }
    it 'returns false for more than 1 hour before the match start' do
      Timecop.freeze(match.played_at - (limit * 60 + 1).minutes) do
        expect(match).to_not be_locked
      end
    end
    it 'returns true when 1 hour before the match start' do
      Timecop.freeze(match.played_at - limit.hour) do
        expect(match).to be_locked
      end
    end
    it 'returns true when less than 1 hour before the match start' do
      Timecop.freeze(match.played_at - (limit * 60 - 1).minutes) do
        expect(match).to be_locked
      end
    end
    it 'returns true after the match has started' do
      Timecop.freeze(match.played_at + 1.minute) do
        expect(match).to be_locked
      end
    end
  end

  describe '#bettable?' do
    let(:limit) { described_class.hours_before_start_time_to_bet }
    context 'when both teams are known' do
      let(:match) { build(:match) }
      it 'returns false for more than 1 hour before the match start' do
        Timecop.freeze(match.played_at - (limit * 60 + 1).minutes) do
          expect(match).to be_bettable
        end
      end
      it 'returns true when 1 hour before the match start' do
        Timecop.freeze(match.played_at - limit.hour) do
          expect(match).to_not be_bettable
        end
      end
      it 'returns true when less than 1 hour before the match start' do
        Timecop.freeze(match.played_at - (limit * 60 - 1).minutes) do
          expect(match).to_not be_bettable
        end
      end
      it 'returns true after the match has started' do
        Timecop.freeze(match.played_at + 1.minute) do
          expect(match).to_not be_bettable
        end
      end
    end
    context 'when not all teams are known' do
      let(:match) { build(:match, team_b: nil) }
      it 'returns false for more than 1 hour before the match start' do
        Timecop.freeze(match.played_at - (limit * 60 + 1).minutes) do
          expect(match).to_not be_bettable
        end
      end
      it 'returns false when 1 hour before the match start' do
        Timecop.freeze(match.played_at - limit.hour) do
          expect(match).to_not be_bettable
        end
      end
      it 'returns false when less than 1 hour before the match start' do
        Timecop.freeze(match.played_at - (limit * 60 - 1).minutes) do
          expect(match).to_not be_bettable
        end
      end
      it 'returns false after the match has started' do
        Timecop.freeze(match.played_at + 1.minute) do
          expect(match).to_not be_bettable
        end
      end
    end
  end

  describe '#result' do
    let(:team_a) { create(:team) }
    let(:team_b) { create(:other_team) }
    let(:group_match) { create(:match, played_at: 1.day.ago, goals_a: 1, goals_b: 0, team_a: team_a, team_b: team_b) }
    let(:final_match) { create(:match, played_at: 1.day.ago, goals_a: 1, goals_b: 0, team_a: team_a, team_b: team_b, round: 'round_16') }
    it 'returns nil if not valid' do
      match = build(:match, played_at: nil)
      expect(match).to_not be_valid
      expect(match.result).to be_nil
    end
    it 'returns nil if not scorable' do
      match = build(:match, played_at: 1.day.from_now, goals_a: 1, goals_b: 0, team_a: team_a, team_b: team_b)
      expect(match).to_not be_scorable
      expect(match.result).to be_nil
    end
    it 'returns team_a as winner' do
      match = build(:match, played_at: 1.day.ago, goals_a: 1, goals_b: 0, team_a: team_a, team_b: team_b)
      expect(match.result).to eql(:team_a)
    end
    it 'returns team_b as winner' do
      match = build(:match, played_at: 1.day.ago, goals_a: 0, goals_b: 1, team_a: team_a, team_b: team_b)
      expect(match.result).to eql(:team_b)
    end
    it 'returns no one as winner (draw)' do
      match = build(:match, played_at: 1.day.ago, goals_a: 0, goals_b: 0, team_a: team_a, team_b: team_b)
      expect(match.result).to eql(:draw)
    end
    it 'returns team_a as winner by penaltys' do
      match = build(:match, played_at: 1.day.ago, goals_a: 1, goals_b: 1, team_a: team_a, team_b: team_b, round: 'round_16', penalty_goals_a: 4, penalty_goals_b: 2)
      expect(match.result).to eql(:team_a)
    end
    it 'returns team_b as winner by penaltys' do
      match = build(:match, played_at: 1.day.ago, goals_a: 1, goals_b: 1, team_a: team_a, team_b: team_b, round: 'round_16', penalty_goals_a: 2, penalty_goals_b: 4)
      expect(match.result).to eql(:team_b)
    end
  end

  describe '#score!' do
    subject { build(:match) }
    it 'delegates to MatchScorer#score_all!' do
      match_scorer = double('MatchScorer', score_all!: true)
      MatchScorer.should_receive(:new).with(subject).and_return(match_scorer)
      match_scorer.should_receive(:score_all!)
      subject.score!
    end
  end

  describe '#betted_by?' do
    let!(:match1) { create(:match) }
    let!(:match2) { create(:future_match) }
    let!(:bet1) { create(:bet, user: create(:user)) }
    let!(:bet2) { create(:bet, user: create(:user_pt)) }
    let!(:match_bet11) { create(:match_bet, bet: bet1, match: match1) }
    let!(:match_bet22) { create(:match_bet, bet: bet2, match: match2) }
    it 'returns true if the match has been betted by the supplied bet, false otherwise' do
      expect(match1.betted_by?(bet1)).to be_true
      expect(match1.betted_by?(bet2)).to be_false
      expect(match2.betted_by?(bet1)).to be_false
      expect(match2.betted_by?(bet2)).to be_true
    end
  end

  describe '#scorable?' do
    let!(:game_time) { Time.zone.now }
    let(:team_a) { create(:team) }
    let(:team_b) { create(:other_team) }
    let(:group_match) { build(:match, round: 'group', played_at: game_time, team_a: team_a, team_b: team_b, goals_a: nil, goals_b: nil) }
    let(:finals_match) { build(:future_match, round: 'quarter', played_at: game_time, team_a: nil, team_b: nil, goals_a: nil, goals_b: nil) }
    context 'when locked' do
      it 'returns true if group phase and has known teams and goals' do
        group_match.should_receive(:locked?).and_return(true)
        group_match.goals_a = 2
        group_match.goals_b = 1
        expect(group_match).to be_scorable
      end
      it 'returns true if group phase and has known teams and goals (when draw)' do
        group_match.should_receive(:locked?).and_return(true)
        group_match.goals_a = 2
        group_match.goals_b = 2
        expect(group_match).to be_scorable
      end
      it 'returns true if finals phase and has known teams and goals' do
        finals_match.should_receive(:locked?).and_return(true)
        finals_match.team_a = team_a
        finals_match.team_b = team_b
        finals_match.goals_a = 2
        finals_match.goals_b = 1
        expect(finals_match).to be_scorable
      end
      it 'returns true if finals phase and has known teams and goals and penalty_goals (when draw)' do
        finals_match.should_receive(:locked?).and_return(true)
        finals_match.team_a = team_a
        finals_match.team_b = team_b
        finals_match.goals_a = 2
        finals_match.goals_b = 2
        finals_match.penalty_goals_a = 4
        finals_match.penalty_goals_b = 3
        expect(finals_match).to be_scorable
      end
      it 'returns false if not known teams' do
        finals_match.should_receive(:locked?).and_return(true)
        expect(finals_match).to_not be_scorable
      end
      it 'returns false if not known goals' do
        group_match.should_receive(:locked?).and_return(true)
        expect(group_match).to_not be_scorable
      end
      it 'returns false if not known penalty goals on draw on finals' do
        finals_match.should_receive(:locked?).and_return(true)
        finals_match.team_a = team_a
        finals_match.team_b = team_b
        finals_match.goals_a = 2
        finals_match.goals_b = 2
        expect(finals_match).to_not be_scorable
      end
    end
    it 'returns false if not locked' do
      group_match.should_receive(:locked?).and_return(false)
      group_match.goals_a = 2
      group_match.goals_b = 1
      expect(group_match).to_not be_scorable
    end
  end

end
