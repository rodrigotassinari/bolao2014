class QuestionBetPresenter < Presenter

  expose :to_key, :to_param,
    :answer,
    :answer_object,
    :points,
    :created_at,
    :updated_at,
    :scored_at,
    :question_id,
    :bet_id

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

  # TODO spec
  def possible_answers_options
    self.send("#{question.answer_type}_possible_answers_options")
  end

  # TODO spec
  def answer_text
    return if answer.blank?
    case question.answer_type
    when 'team'
      answer_object.name_and_acronym
    when 'player'
      answer_object.name_position_and_team
    when 'boolean'
      {'true' => t('common.yesyes'), 'false' => t('common.nono')}[answer.to_s]
    end
  end

  def answer_text_if_locked
    if @subject.question.locked?
      answer_text
    else
      h.content_tag(:span, '?', 'data-tooltip' => true, 'class' => 'has-tip', 'title' => t('question_bet_presenter.will_show_when_question_locked'))
    end
  end

  # TODO spec
  def points_with_explanation
    if @subject.scored?
      tooltip_span(@subject.points.to_s, points_explanation, 'points known')
    else
      tooltip_span('?', t('question_bet_presenter.will_show_when_question_scored'), 'points unknown')
    end
  end

  private

  def tooltip_span(text, title, extra_css_class)
    h.content_tag(:span, text, 'data-tooltip' => true, 'class' => "has-tip #{extra_css_class}", 'title' => title)
  end

  def points_explanation
    t(
      "question_bet_presenter.got_the_answer_#{@subject.correct_answer? ? 'right' : 'wrong'}",
      points: @subject.points
    )
  end

  def team_possible_answers_options
    h.options_from_collection_for_select(question.possible_answers, :id, :name_and_acronym, answer_literal)
  end

  def player_possible_answers_options
    h.options_from_collection_for_select(question.possible_answers, :id, :name_position_and_team, answer_literal)
  end

  def boolean_possible_answers_options
    h.options_for_select({t('common.yesyes') => 'true', t('common.nono') => 'false'}, answer_literal)
  end

  def answer_literal
    return if answer.blank?
    case question.answer_type
    when 'team'
      Integer(answer)
    when 'player'
      Integer(answer)
    when 'boolean'
      answer.to_s
    end
  end

end
