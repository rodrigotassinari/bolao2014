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
    :bettable_until

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

end
