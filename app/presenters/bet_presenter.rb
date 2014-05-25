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

  # TODO spec
  def matches_count
    @subject.matches.count
  end

  # TODO spec
  def questions_count
    @subject.questions.count
  end

end
