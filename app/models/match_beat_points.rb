class MatchBeatPoints

  def self.points(match_bet)
    match = match_bet.match
    return 0 if !match.played?
    if match.tie?
      return 10 if match.goals_a == match_bet.goals_a && match.goals_b == match_bet.goals_b
      6
    elsif match_winner(match) == bet_winner(match_bet)
      return 10 if match.goals_a == match_bet.goals_a && match.goals_b == match_bet.goals_b
      return 8 if (match.goals_a == match_bet.goals_a) || (match.goals_b == match_bet.goals_b)
      6
    else
      return 2 if (match.goals_a == match_bet.goals_a) || (match.goals_b == match_bet.goals_b)
      0
    end
  end

  private

  def self.match_winner(match)
    match.team_a if match.goals_a > match.goals_b
    match.team_b if match.goals_b > match.goals_a
  end

  def self.bet_winner(match)
    match.match.team_a if match.goals_a > match.goals_b
    match.match.team_b if match.goals_b > match.goals_a
  end

end