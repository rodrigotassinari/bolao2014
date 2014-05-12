class MatchBetPresenter < Presenter

  expose :to_key, :to_param,
    :goals_a,
    :goals_b,
    :penalty_winner_id,
    :points,
    :created_at,
    :updated_at

  # TODO spec
  def css_id
    "match_bets_#{@subject.id}"
  end

  def bet
    @subject.bet
    # @bet_presenter ||= BetPresenter.new(@subject.bet) # TODO
  end

  def match
    @match_presenter ||= MatchPresenter.new(@subject.match)
  end

end
