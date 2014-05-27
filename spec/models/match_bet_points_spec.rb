require 'spec_helper'

describe MatchBetPoints do

  describe '.points' do
    let(:team_a) { create(:team) }
    let(:team_b) { create(:other_team) }
    let(:match) { create(:match, number: 1, played_at: 1.day.ago, goals_a: 2, goals_b: 0, team_a: team_a, team_b: team_b) }
    let(:finals_match) { create(:match, number: 2, played_at: 1.day.ago, goals_a: 1, goals_b: 1, penalty_goals_a: 2, penalty_goals_b: 4, team_a: team_a, team_b: team_b, round: 'round_16') }
    let(:match_bet) { build(:match_bet, match: match) }
    context 'when all is wrong' do
      it 'scores 0 points' do
        expect(MatchBetPoints.new(build(:match_bet, match: match, goals_a: 0, goals_b: 1)).points).to eql(0)
      end
    end
    context 'when all is correct' do
      it 'scores full points' do
        expect(MatchBetPoints.new(build(:match_bet, match: match, goals_a: 2, goals_b: 0)).points).to eql(match.total_points)
      end
    end
    context 'when only goals_a is correct' do
      it 'scores one goals points' do
        expect(MatchBetPoints.new(build(:match_bet, match: match, goals_a: 2, goals_b: 3)).points).to eql(match.goal_points * 1)
      end
    end
    context 'when only goals_b is correct' do
      it 'scores one goals points' do
        expect(MatchBetPoints.new(build(:match_bet, match: match, goals_a: 0, goals_b: 0)).points).to eql(match.goal_points * 1)
      end
    end
    context 'when only result is correct' do
      it 'scores result points' do
        expect(MatchBetPoints.new(build(:match_bet, match: match, goals_a: 3, goals_b: 2)).points).to eql(match.result_points)
      end
    end
    context 'when result and goals_a is correct' do
      it 'scores result and one goals points' do
        expect(MatchBetPoints.new(build(:match_bet, match: match, goals_a: 2, goals_b: 1)).points).to eql(match.result_points + match.goal_points)
      end
    end
    context 'when result and goals_b is correct' do
      it 'scores result and one goals points' do
        expect(MatchBetPoints.new(build(:match_bet, match: match, goals_a: 3, goals_b: 0)).points).to eql(match.result_points + match.goal_points)
      end
    end
    context 'when goals are corrent but not result' do
      it 'scores two goals points' do
        expect(MatchBetPoints.new(build(:match_bet, match: finals_match, goals_a: 1, goals_b: 1, penalty_winner_id: team_a.id)).points).to eql(match.goal_points * 2)
      end
    end
  end

end
