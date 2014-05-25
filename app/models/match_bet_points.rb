class MatchBetPoints

  def self.points(match_bet)
    match = match_bet.match
    return 0 if !match.played?
    points = 0
    points += match.result_points if (match.goals_a == match_bet.goals_a && match.goals_b == match_bet.goals_b && match.drawable?) || match.result == match_bet.result
    points += match.goal_points if match.goals_a == match_bet.goals_a
    points += match.goal_points if match.goals_b == match_bet.goals_b
    points
  end

end