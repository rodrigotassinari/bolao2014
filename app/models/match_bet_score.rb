class MatchBetScore

  def self.update(match)
    match.match_bets.find_each do |match_bet|
      match_bet.points = MatchBetPoints.new(match_bet).points
      match_bet.scored_at = Time.zone.now
      match_bet.save!
    end
  end

end