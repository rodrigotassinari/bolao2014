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

  private

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
