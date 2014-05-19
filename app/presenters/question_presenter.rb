class QuestionPresenter < Presenter

  expose :to_key, :to_param,
    :body,
    :body_en,
    :body_pt,
    :played_at,
    :answer_type,
    :answer,
    :locked?,
    :bettable?,
    :bettable_until,
    :number

  # TODO spec
  def css_id
    "questions_#{@subject.id}"
  end

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

  def link_to_next
    if @subject.next
      h.link_to(I18n.t('question_presenter.next_question'), r.question_bet_path(@subject.next))
    else
      h.content_tag(:span, I18n.t('question_presenter.no_next_question'))
    end
  end

  def link_to_previous
    if @subject.previous
      h.link_to(I18n.t('question_presenter.previous_question'), r.question_bet_path(@subject.previous))
    else
      h.content_tag(:span, I18n.t('question_presenter.no_previous_question'))
    end
  end

end
