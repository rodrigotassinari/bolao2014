class QuestionBetPresenter < Presenter

  expose :to_key, :to_param,
    :answer,
    :answer_object,
    :points,
    :created_at,
    :updated_at

  # TODO spec
  def css_id
    "question_bets_#{@subject.id}"
  end

  def bet
    @bet_presenter ||= BetPresenter.new(@subject.bet) if @subject.bet
  end

  def question
    @question_presenter ||= QuestionPresenter.new(@subject.question) if @subject.question
  end

end
