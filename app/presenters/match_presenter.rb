class MatchPresenter < Presenter

  expose :to_key, :to_param,
    :id,
    :number,
    :round,
    :group,
    :played_at,
    :played_on,
    :played_on_text,
    :goals_a,
    :goals_b,
    :penalty_goals_a,
    :penalty_goals_b,
    :locked?,
    :bettable?,
    :bettable_until,
    :played?

  # TODO spec
  def css_id
    "matches_#{@subject.id}"
  end

  def link_to_next
    if @subject.next
      h.link_to(I18n.t('match_presenter.next_match'), r.match_bet_path(@subject.next))
    else
      h.content_tag(:span, I18n.t('match_presenter.no_next_match'))
    end
  end

  def link_to_previous
    if @subject.previous
      h.link_to(I18n.t('match_presenter.previous_match'), r.match_bet_path(@subject.previous))
    else
      h.content_tag(:span, I18n.t('match_presenter.no_previous_match'))
    end
  end

  # TODO spec
  def link_to_next_bettable
    if @subject.next_bettable
      h.link_to(I18n.t('match_presenter.next_bettable_match'), r.match_bet_path(@subject.next))
    else
      h.content_tag(:span, I18n.t('match_presenter.no_next_bettable_match'))
    end
  end

  # TODO spec
  def link_to_previous_bettable
    if @subject.previous_bettable
      h.link_to(I18n.t('match_presenter.previous_bettable_match'), r.match_bet_path(@subject.previous))
    else
      h.content_tag(:span, I18n.t('match_presenter.no_previous_bettable_match'))
    end
  end

  def betted_by?(bet)
    @subject.betted_by?(bet)
  end

  def round_text
    return if @subject.round.blank?
    I18n.t("activerecord.attributes.match.group_text.#{@subject.round}")
  end

  def team_a
    @team_a_presenter ||= TeamPresenter.new(@subject.team_a) if @subject.team_a
  end

  # TODO spec
  def team_a_flag(width=42, length=28)
    team_flag(:a, width, length)
  end

  # TODO spec
  def team_a_name
    team_name(:a)
  end

  # TODO spec
  def team_a_info
    team_info(:a)
  end

  def team_b
    @team_b_presenter ||= TeamPresenter.new(@subject.team_b) if @subject.team_b
  end

  # TODO spec
  def team_b_flag(width=42, length=28)
    team_flag(:b, width, length)
  end

  # TODO spec
  def team_b_name
    team_name(:b)
  end

  # TODO spec
  def team_b_info
    team_info(:b)
  end

  private

  def team_flag(letter, width=42, length=28)
    team = @subject.send("team_#{letter}")
    h.image_tag("flags/#{team.acronym}.png", class: 'team-flag', alt: "#{team.acronym} flag", width: width, length: length)
  end

  def team_name(letter)
    team = @subject.send("team_#{letter}")
    h.content_tag(:span, team.name, class: 'team-name')
  end

  def team_info(letter)
    team = @subject.send("team_#{letter}")
    return '???' unless team.present?
    info = [
      team_flag(letter),
      team_name(letter),
      h.content_tag(:span, (@subject.send("goals_#{letter}") || '?'), class: 'match-goal')
    ]
    info.reverse! if letter == :b
    info.join("\n").html_safe
  end

end
