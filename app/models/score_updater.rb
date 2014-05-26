class ScoreUpdater

  def self.update_match(match)
    match.match_bets.find_each do |match_bet|
      match_bet.points = MatchBetPoints.new(match_bet).points
      match_bet.scored_at = Time.zone.now
      match_bet.save!
      bet = match_bet.bet
      previous_points = bet.points
      update_bet(bet)
      current_points = bet.points
      UsersMailer.async_deliver(
        :match_bet_scored,
        match_bet.id,
        previous_points,
        current_points
      )
    end
  end

  def self.update_bet(bet)
    bet.points = bet.match_bets.sum(:points) + bet.question_bets.sum(:points)
    bet.save!
  end
end