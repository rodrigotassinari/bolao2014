class ScoreUpdater

  def self.update_match(match)
    match.match_bets.find_each do |match_bet|
      match_bet.points = MatchBetPoints.new(match_bet).points
      match_bet.scored_at = Time.zone.now
      match_bet.save!
    end
    # TODO: change it to use SQL
    affected_bets = Bet.joins(:matches).where(["matches.id = ?", match.id])
    affected_bets.find_each do |bet|
      update_bet(bet)
    end
  end

  def self.update_bet(bet)
    bet.points = bet.match_bets.sum(:points) + bet.question_bets.sum(:points)
    bet.save!
  end
end