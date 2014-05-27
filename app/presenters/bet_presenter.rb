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
    @match_bets ||= MatchBetPresenter.map(@subject.match_bets.all.sort_by { |mb| mb.match.number })
  end

  def question_bets
    @question_bets ||= QuestionBetPresenter.map(@subject.question_bets.all.sort_by { |mb| mb.question.number })
  end

  def match_bets_points
    @subject.match_bets.sum(:points)
  end

  def question_bets_points
    @subject.question_bets.sum(:points)
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
  def bettable_matches_count
    @subject.bettable_matches.count
  end

  # TODO spec
  def bettable_questions_count
    @subject.bettable_questions.count
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
