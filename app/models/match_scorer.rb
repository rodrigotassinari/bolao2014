class MatchScorer
  # include Scorer # TODO?

  attr_reader :match

  # TODO spec
  def initialize(match)
    @match = match
  end

  # Score all existing match_bets for this match (calculates the points and saves on the match_bets).
  # Can be run any number of times.
  # TODO spec
  def score_all!
    false # TODO
  end

end
