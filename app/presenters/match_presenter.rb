class MatchPresenter < Presenter

  expose :to_key, :to_param,
    :number,
    :round,
    :group,
    :played_at,
    :played_on,
    :played_on_text,
    :team_a,
    :team_b,
    :goals_a,
    :goals_b,
    :penalty_goals_a,
    :penalty_goals_b

  # TODO spec
  def css_id
    "matches_#{@subject.id}"
  end

  # TODO spec
  def team_a_info
    team_info(:a)
  end

  # TODO spec
  def team_b_info
    team_info(:b)
  end

  private

  def team_info(letter)
    team = @subject.send("team_#{letter}")
    return '???' unless team.present?
    info = [
      h.image_tag("flags/#{team.acronym}.png", class: 'team-flag', width: 42, length: 28),
      h.content_tag(:span, team.name, class: 'team-name'),
      h.content_tag(:span, (@subject.send("goals_#{letter}") || '?'), class: 'match-goal')
    ]
    info.reverse! if letter == :b
    info.join("\n").html_safe
  end

end
