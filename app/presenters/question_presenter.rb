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
    return if @subject.answer.blank?
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
      h.content_tag(:span, '?', 'data-tooltip' => true, 'class' => 'answer_ unknown has-tip', 'title' => t('question_presenter.no_answer_yet'))
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

end
