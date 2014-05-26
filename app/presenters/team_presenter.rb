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

  def flag(width=42, length=28)
    h.image_tag("flags/#{@subject.acronym}.png", class: 'team-flag', alt: "#{@subject.acronym} flag", width: width, length: length)
  end

end
