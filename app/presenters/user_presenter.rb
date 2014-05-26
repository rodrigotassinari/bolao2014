class UserPresenter < Presenter

  expose :to_key, :to_param,
    :name,
    :email,
    :time_zone,
    :locale,
    :created_at,
    :updated_at,
    :name_or_email,
    :email_with_name

  # TODO spec
  def css_id
    "users_#{@subject.id}"
  end

  def bet
    @bet_presenter ||= BetPresenter.new(@subject.bet) if @subject.bet
  end

end
