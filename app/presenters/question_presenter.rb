class QuestionPresenter < Presenter

  expose :to_key, :to_param,
    :id,
    :body,
    :body_en,
    :body_pt,
    :played_at,
    :answer_type,
    :answered?,
    :locked?,
    :bettable?,
    :bettable_until,
    :number,
    :possible_answers

  # TODO spec
  def css_id
    "questions_#{@subject.id}"
  end

  def question_bets
    QuestionBetPresenter.map(@subject.question_bets.all)
  end


  # TODO spec
  def answer
    if @subject.answer.blank?
      I18n.t('question_presenter.no_answer_yet')
    else
      @subject.answer
    end
  end

  # TODO spec
  def answer_object
    @obj ||= @subject.answer_object
    case @obj.class.to_s
    when 'Team'
      TeamPresenter.new(@obj)
    when 'Player'
      PlayerPresenter.new(@obj)
    else
      @obj
    end
  end

  def answer_text
    return answer if @subject.answer.blank?
    case @subject.answer_type
    when 'team'
      answer_object.name_and_acronym
    when 'player'
      answer_object.name_position_and_team
    when 'boolean'
      {'true' => t('common.yesyes'), 'false' => t('common.nono')}[@subject.answer.to_s]
    end
  end

  # TODO spec
  def answer_text_or_?
    if answer_text.present?
      h.content_tag(:span, answer_text, class: 'answer')
    else
      h.content_tag(:span, '?', 'class' => 'answer_ unknown has-tip', 'title' => t('question_presenter.no_answer_yet'))
    end
  end

  def betted_by?(bet)
    @subject.betted_by?(bet)
  end

  # TODO spec
  def link_to_next
    if @subject.next
      h.link_to(I18n.t('question_presenter.next_question'), r.question_path(@subject.next))
    else
      h.content_tag(:span, I18n.t('question_presenter.no_next_question'))
    end
  end

  # TODO spec
  def link_to_previous
    if @subject.previous
      h.link_to(I18n.t('question_presenter.previous_question'), r.question_path(@subject.previous))
    else
      h.content_tag(:span, I18n.t('question_presenter.no_previous_question'))
    end
  end

  # TODO spec
  def link_to_next_admin
    if @subject.next
      h.link_to(I18n.t('question_presenter.next_question'), r.admin_question_path(@subject.next))
    else
      h.content_tag(:span, I18n.t('question_presenter.no_next_question'))
    end
  end

  # TODO spec
  def link_to_previous_admin
    if @subject.previous
      h.link_to(I18n.t('question_presenter.previous_question'), r.admin_question_path(@subject.previous))
    else
      h.content_tag(:span, I18n.t('question_presenter.no_previous_question'))
    end
  end

  def link_to_next_admin_edit
    if @subject.next
      h.link_to(I18n.t('question_presenter.next_question'), r.edit_admin_question_path(@subject.next))
    else
      h.content_tag(:span, I18n.t('question_presenter.no_next_question'))
    end
  end

  def link_to_previous_admin_edit
    if @subject.previous
      h.link_to(I18n.t('question_presenter.previous_question'), r.edit_admin_question_path(@subject.previous))
    else
      h.content_tag(:span, I18n.t('question_presenter.no_previous_question'))
    end
  end

  # TODO spec
  def link_to_next_to_bet
    if @subject.next
      h.link_to(I18n.t('question_presenter.next_question'), r.my_question_bet_path(@subject.next))
    else
      h.content_tag(:span, I18n.t('question_presenter.no_next_question'))
    end
  end

  # TODO spec
  def link_to_previous_to_bet
    if @subject.previous
      h.link_to(I18n.t('question_presenter.previous_question'), r.my_question_bet_path(@subject.previous))
    else
      h.content_tag(:span, I18n.t('question_presenter.no_previous_question'))
    end
  end

  # TODO spec
  def possible_answers_options(answer_literal=nil)
    answer_literal ||= question_answer_literal
    self.send("#{@subject.answer_type}_possible_answers_options", answer_literal)
  end

  private

  def team_possible_answers_options(answer_literal)
    h.options_from_collection_for_select(@subject.possible_answers, :id, :name_and_acronym, answer_literal)
  end

  def player_possible_answers_options(answer_literal)
    h.options_from_collection_for_select(@subject.possible_answers, :id, :name_position_and_team, answer_literal)
  end

  def boolean_possible_answers_options(answer_literal)
    h.options_for_select({t('common.yesyes') => 'true', t('common.nono') => 'false'}, answer_literal)
  end

  def question_answer_literal
    return if @subject.answer.blank?
    case @subject.answer_type
    when 'team'
      Integer(answer)
    when 'player'
      Integer(answer)
    when 'boolean'
      answer.to_s
    end
  end

end
