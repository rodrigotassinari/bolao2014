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
    :played?,
    :drawable?,
    :with_known_teams?,
    :with_known_goals?,
    :with_known_penalty_goals?,
    :errors

  def self.model_name
    Match.model_name
  end

  # TODO spec
  def css_id
    "matches_#{@subject.id}"
  end

  # TODO spec
  def teams_select_options(which_one)
    h.options_from_collection_for_select(Team.ordered.all, :id, :name_and_acronym, @subject.send(which_one))
  end

  # TODO spec
  def admin_edit_team_partial
    if @subject.locked? || @subject.round == 'group'
      'admin/matches/non_editable_team'
    else
      'admin/matches/editable_team'
    end
  end

  def one_line_summary
    summary = "#{@subject.team_a.name} #{@subject.goals_a} x #{@subject.goals_b} #{@subject.team_b.name}"
    if @subject.penalty_goals_a.present? && @subject.penalty_goals_b.present?
      summary << I18n.t('match_presenter.with_penaltys')
      summary << "#{@subject.team_a.name} #{@subject.penalty_goals_a} x #{@subject.penalty_goals_b} #{@subject.team_b.name}"
    end
    summary
  end

  def group_or_na
    @subject.group.blank? ? I18n.t('match_presenter.no_group') : @subject.group
  end

  def link_to_next
    if @subject.next
      h.link_to(I18n.t('match_presenter.next_match'), r.match_path(@subject.next))
    else
      h.content_tag(:span, I18n.t('match_presenter.no_next_match'))
    end
  end

  def link_to_previous
    if @subject.previous
      h.link_to(I18n.t('match_presenter.previous_match'), r.match_path(@subject.previous))
    else
      h.content_tag(:span, I18n.t('match_presenter.no_previous_match'))
    end
  end

  def link_to_next_admin
    if @subject.next
      h.link_to(I18n.t('match_presenter.next_match'), r.admin_match_path(@subject.next))
    else
      h.content_tag(:span, I18n.t('match_presenter.no_next_match'))
    end
  end

  def link_to_previous_admin
    if @subject.previous
      h.link_to(I18n.t('match_presenter.previous_match'), r.admin_match_path(@subject.previous))
    else
      h.content_tag(:span, I18n.t('match_presenter.no_previous_match'))
    end
  end

  def link_to_next_admin_edit
    if @subject.next
      h.link_to(I18n.t('match_presenter.next_match'), r.edit_admin_match_path(@subject.next))
    else
      h.content_tag(:span, I18n.t('match_presenter.no_next_match'))
    end
  end

  def link_to_previous_admin_edit
    if @subject.previous
      h.link_to(I18n.t('match_presenter.previous_match'), r.edit_admin_match_path(@subject.previous))
    else
      h.content_tag(:span, I18n.t('match_presenter.no_previous_match'))
    end
  end

  def link_to_next_to_bet
    if @subject.next
      h.link_to(I18n.t('match_presenter.next_match'), r.my_match_bet_path(@subject.next))
    else
      h.content_tag(:span, I18n.t('match_presenter.no_next_match'))
    end
  end

  def link_to_previous_to_bet
    if @subject.previous
      h.link_to(I18n.t('match_presenter.previous_match'), r.my_match_bet_path(@subject.previous))
    else
      h.content_tag(:span, I18n.t('match_presenter.no_previous_match'))
    end
  end

  # TODO spec
  def link_to_next_bettable
    if @subject.next_bettable
      h.link_to(I18n.t('match_presenter.next_bettable_match'), r.my_match_bet_path(@subject.next))
    else
      h.content_tag(:span, I18n.t('match_presenter.no_next_bettable_match'))
    end
  end

  # TODO spec
  def link_to_previous_bettable
    if @subject.previous_bettable
      h.link_to(I18n.t('match_presenter.previous_bettable_match'), r.my_match_bet_path(@subject.previous))
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

  def team_a_flag_or_?(width=42, length=28)
    team_flag_or_?(:a, width, length)
  end

  # TODO spec
  def team_a_name
    team_name(:a)
  end

  def team_a_name_or_?
    team_name_or_?(:a)
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

  def team_b_flag_or_?(width=42, length=28)
    team_flag_or_?(:b, width, length)
  end

  # TODO spec
  def team_b_name
    team_name(:b)
  end

  def team_b_name_or_?
    team_name_or_?(:b)
  end

  # TODO spec
  def team_b_info
    team_info(:b)
  end

  def goals_a_or_?
    goals_or_?(:goals, :a)
  end

  def goals_b_or_?
    goals_or_?(:goals, :b)
  end

  def penalty_goals_a_or_?
    goals_or_?(:penalty_goals, :a)
  end

  def penalty_goals_b_or_?
    goals_or_?(:penalty_goals, :b)
  end

  private

  def goals_or_?(type, letter)
    goal = @subject.send("#{type}_#{letter}")
    if goal.present?
      h.content_tag(:span, goal.to_s, class: 'goal')
    else
      h.content_tag(:span, '?', 'class' => 'goal unknown has-tip', 'title' => t('match_presenter.not_yet_known'))
    end
  end

  def flag_image(name, width=42, length=28)
    h.image_tag("flags/#{name}.png", class: "team-flag #{name}", alt: "#{name} flag", width: width, length: length)
  end

  def team_flag(letter, width=42, length=28)
    team = @subject.send("team_#{letter}")
    return '' unless team.present?
    flag_image(team.acronym, width, length)
  end

  def team_flag_or_?(letter, width=42, length=28)
    team = @subject.send("team_#{letter}")
    if team
      flag_image(team.acronym, width, length)
    else
      flag_image('unknown', width, length)
    end
  end

  def team_name(letter)
    team = @subject.send("team_#{letter}")
    return '' unless team.present?
    h.content_tag(:span, team.name, class: 'team-name')
  end

  def team_name_or_?(letter)
    team = @subject.send("team_#{letter}")
    if team
      h.content_tag(:span, team.name, class: 'team-name')
    else
      h.content_tag(:span, '?', 'class' => 'team-name unknown has-tip', 'title' => t('match_presenter.not_yet_known'))
    end
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
