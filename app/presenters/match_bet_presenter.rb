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

  # TODO spec
  def form_id
    return if @subject.match.blank?
    if @subject.match.drawable?
      'match_bet_form'
    else
      'no_draw_match_bet_form'
    end
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

  # TODO spec
  def teams_options_for_select
    team_a = @subject.match.team_a
    team_b = @subject.match.team_b
    h.options_for_select(
      {team_a.name => team_a.id, team_b.name => team_b.id},
      @subject.penalty_winner_id
    )
  end

  # TODO spec
  def penalty_winner_select_visible?
    @subject.goals_a.present? &&
      @subject.goals_b.present? &&
      @subject.goals_a == @subject.goals_b
  end

  private

  def goals_or_blank(letter)
    goals = @subject.send("goals_#{letter}")
    goals.blank? ? 'N/A' : goals.to_s
  end

end
