class BetPresenter < Presenter

  expose :to_key, :to_param,
    :points,
    :created_at,
    :updated_at

  # TODO spec
  def css_id
    "bets_#{@subject.id}"
  end

  def user
    @user_presenter ||= UserPresenter.new(@subject.user) if @subject.user
  end

end
