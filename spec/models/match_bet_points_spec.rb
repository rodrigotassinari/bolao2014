require 'spec_helper'

describe MatchBeatPoints do

  let(:match) { build(:match, round: 'group') }

  context "round matches" do
    it "returns 10 for tie bet with the correct score" do
      match.update_attributes!(goals_a: 1, goals_b: 1, played_at: Date.yesterday)
      match_bet = build(:match_bet, match: match, goals_a: 1, goals_b: 1)
      expect(MatchBeatPoints.points(match_bet)).to eq(10)
    end

    it "returns 6 for tie bet without the correct score" do
      match.update_attributes!(goals_a: 2, goals_b: 2, played_at: Date.yesterday)
      match_bet = build(:match_bet, match: match, goals_a: 1, goals_b: 1)
      expect(MatchBeatPoints.points(match_bet)).to eq(6)
    end

    it "returns 6 for bet with the correct winner but incorrect number of goals for both teams" do
      match.update_attributes!(goals_a: 3, goals_b: 1, played_at: Date.yesterday)
      match_bet = build(:match_bet, match: match, goals_a: 4, goals_b: 2)
      expect(MatchBeatPoints.points(match_bet)).to eq(6)
    end

    it "returns 10 for bet with the correct winner and correct number of goals for both teams" do
      match.update_attributes!(goals_a: 3, goals_b: 1, played_at: Date.yesterday)
      match_bet = build(:match_bet, match: match, goals_a: 3, goals_b: 1)
      expect(MatchBeatPoints.points(match_bet)).to eq(10)
    end

    it "returns 8 for bet with the correct winner and correct number of goals for team a" do
      match.update_attributes!(goals_a: 3, goals_b: 1, played_at: Date.yesterday)
      match_bet = build(:match_bet, match: match, goals_a: 3, goals_b: 2)
      expect(MatchBeatPoints.points(match_bet)).to eq(8)
    end

    it "returns 8 for bet with the correct winner and correct number of goals for team b" do
      match.update_attributes!(goals_a: 3, goals_b: 1, played_at: Date.yesterday)
      match_bet = build(:match_bet, match: match, goals_a: 2, goals_b: 1)
      expect(MatchBeatPoints.points(match_bet)).to eq(8)
    end

    it "returns 2 for bet with the incorrect winner and correct number of goals for team b" do
      match.update_attributes!(goals_a: 3, goals_b: 1, played_at: Date.yesterday)
      match_bet = build(:match_bet, match: match, goals_a: 0, goals_b: 1)
      expect(MatchBeatPoints.points(match_bet)).to eq(2)
    end
  end

  context "not round matches" do
    it "returns 6 for bet with the correct winner but incorrect number of goals for both teams" do
      match.update_attributes!(goals_a: 3, goals_b: 1, played_at: Date.yesterday, round: 'round_16')
      match_bet = build(:match_bet, match: match, goals_a: 4, goals_b: 2)
      expect(MatchBeatPoints.points(match_bet)).to eq(6)
    end

    it "returns 10 for bet with the correct winner and correct number of goals for both teams" do
      match.update_attributes!(goals_a: 3, goals_b: 1, played_at: Date.yesterday, round: 'round_16')
      match_bet = build(:match_bet, match: match, goals_a: 3, goals_b: 1)
      expect(MatchBeatPoints.points(match_bet)).to eq(10)
    end

    it "returns 8 for bet with the correct winner and correct number of goals for team a" do
      match.update_attributes!(goals_a: 3, goals_b: 1, played_at: Date.yesterday, round: 'round_16')
      match_bet = build(:match_bet, match: match, goals_a: 3, goals_b: 2)
      expect(MatchBeatPoints.points(match_bet)).to eq(8)
    end

    it "returns 8 for bet with the correct winner and correct number of goals for team b" do
      match.update_attributes!(goals_a: 3, goals_b: 1, played_at: Date.yesterday, round: 'round_16')
      match_bet = build(:match_bet, match: match, goals_a: 2, goals_b: 1)
      expect(MatchBeatPoints.points(match_bet)).to eq(8)
    end

    it "returns 2 for bet with the incorrect winner and correct number of goals for team b" do
      match.update_attributes!(goals_a: 3, goals_b: 1, played_at: Date.yesterday, round: 'round_16')
      match_bet = build(:match_bet, match: match, goals_a: 0, goals_b: 1)
      expect(MatchBeatPoints.points(match_bet)).to eq(2)
    end
  end

end
