class PlayerPresenter < Presenter

  expose :to_key, :to_param,
    :name,
    :position,
    :name_position_and_team

  # TODO spec
  def css_id
    "players_#{@subject.id}"
  end

  def team
    @team_presenter ||= TeamPresenter.new(@subject.team) if @subject.team
  end

end
