class MatchBetScore
  
  def self.update(match)
    match.match_bets.find_each do |match_bet|
      match_bet.points = MatchBetPoints.points(match_bet)
      match_bet.scored_at = Time.zone.now
      match_bet.save!
    end
  end
  
end