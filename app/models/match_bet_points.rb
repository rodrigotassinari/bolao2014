class MatchBetPoints

  attr_reader :match_bet

  def initialize(match_bet)
    @match_bet = match_bet
  end

  def points
    @points = 0
    @points += result_points
    @points += goals_a_points
    @points += goals_b_points
    @points
  end

  # Returns true if the match_bet result is correct (matches the match result). The
  # result is the winner of the match (or a draw).
  # TODO spec
  def correct_result?
    match_bet.match.scorable? && match_bet.result == match_bet.match.result
  end

  # TODO spec
  def correct_goals_a?
    match_bet.match.scorable? && match_bet.goals_a == match_bet.match.goals_a
  end

  # TODO spec
  def correct_goals_b?
    match_bet.match.scorable? && match_bet.goals_b == match_bet.match.goals_b
  end

  # TODO spec
  def result_points
    correct_result? ? match_bet.match.result_points : 0
  end

  # TODO spec
  def goals_a_points
    correct_goals_a? ? match_bet.match.goal_points : 0
  end

  # TODO spec
  def goals_b_points
    correct_goals_b? ? match_bet.match.goal_points : 0
  end

end