class TeamPresenter < Presenter

  expose :to_key, :to_param,
    :name,
    :name_en,
    :name_pt,
    :acronym,
    :group,

  # TODO spec
  def css_id
    "teams_#{@subject.id}"
  end

end
