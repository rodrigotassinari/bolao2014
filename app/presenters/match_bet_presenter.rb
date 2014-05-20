class MatchBetPresenter < Presenter

  expose :to_key, :to_param,
    :goals_a,
    :goals_b,
    :penalty_winner_id,
    :points,
    :created_at,
    :updated_at,
    :match_id,
    :bet_id

  # TODO spec
  def css_id
    "match_bets_#{@subject.id}"
  end

  def goals_a_or_blank
    goals_or_blank(:a)
  end

  def goals_b_or_blank
    goals_or_blank(:b)
  end

  def bet
    @bet_presenter ||= BetPresenter.new(@subject.bet) if @subject.bet
  end

  def match
    @match_presenter ||= MatchPresenter.new(@subject.match) if @subject.match
  end

  private

  def goals_or_blank(letter)
    goals = @subject.send("goals_#{letter}")
    goals.blank? ? 'N/A' : goals.to_s
  end

end
