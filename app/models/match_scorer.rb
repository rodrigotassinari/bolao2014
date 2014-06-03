class MatchScorer
  # include EventScorer # TODO?

  attr_reader :match

  def initialize(match)
    @match = match
  end

  # Score all existing match_bets for this match (calculates the points and saves on the match_bets).
  # Can be run any number of times.
  def score_all!
    match.match_bets.find_each do |match_bet|
      match_bet.score!
    end
  end

end
