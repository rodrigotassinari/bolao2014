class BetPresenter < Presenter

  expose :to_key, :to_param,
    :points,
    :created_at,
    :updated_at,
    :paid?,
    :paying?,
    :cost,
    :to_prize,
    :payment_deadline,
    :prize_split,
    :score

  # TODO spec
  def css_id
    "bets_#{@subject.id}"
  end

  def user
    @user_presenter ||= UserPresenter.new(@subject.user) if @subject.user
  end

  def match_bets
    @match_bets ||= MatchBetPresenter.map(@subject.match_bets.all)
  end

  # TODO spec
  def matches_count
    @subject.matches.count
  end

  # TODO spec
  def questions_count
    @subject.questions.count
  end

  # TODO spec
  def match_bets_percentage
    h.number_to_percentage @subject.match_bets_percentage, precision: 2
  end

  # TODO spec
  def question_bets_percentage
    h.number_to_percentage @subject.question_bets_percentage, precision: 2
  end

  # TODO spec
  def percentage
    h.number_to_percentage @subject.percentage, precision: 2
  end

  # TODO spec
  def payment_status
    return t('bet_presenter.paid') if @subject.paid?
    return t('bet_presenter.paying') if @subject.paying?
    t('bet_presenter.unpaid')
  end

end
