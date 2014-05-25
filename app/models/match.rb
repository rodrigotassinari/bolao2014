class Match < ActiveRecord::Base
  include BettableEvent

  ROUNDS = %w( group round_16 quarter semi final )
  GROUPS = %w( A B C D E F G H )
  VENUES = {
    'am' => 'Arena Amazônia, Manaus, AM',
    'ba' => 'Arena Fonte Nova, Salvador, BA',
    'ce' => 'Estádio Castelão, Fortaleza, CE',
    'df' => 'Estádio Nacional (Mané Garrincha), Brasília, DF',
    'mg' => 'Estádio Mineirão, Belo Horizonte, MG',
    'mt' => 'Arena Pantanal, Cuiabá, MT',
    'pe' => 'Arena Pernambuco, Recife, PE',
    'pr' => 'Arena da Baixada, Curitiba, PR',
    'rj' => 'Estádio Jornalista Mário Filho (Maracanã), Rio de Janeiro, RJ',
    'rn' => 'Estádio das Dunas, Natal, RN',
    'rs' => 'Estádio Beira-Rio, Porto Alegre, RS',
    'sp' => 'Arena de São Paulo (Itaquerão), São Paulo, SP',
  }

  belongs_to :team_a, class_name: 'Team'
  belongs_to :team_b, class_name: 'Team'
  has_many :match_bets

  after_update :update_match_bets

  # belongs_to :winner, :class_name => 'Team' # TODO add winner_id to matches
  # belongs_to :loser, :class_name => 'Team' # TODO add loser_id to matches

  validates :round,
    presence: true,
    inclusion: { in: ROUNDS, allow_blank: true }

  validates :group,
    inclusion: { in: GROUPS, allow_blank: true }

  validates :played_on,
    presence: true,
    inclusion: { in: VENUES.keys, allow_blank: true }

  validates :goals_a,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  validates :goals_b,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  validates :penalty_goals_a,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  validates :penalty_goals_b,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  validate :teams_are_not_the_same

  validate :teams_must_be_of_the_same_group_as_the_match

  validate :no_draw_after_group_phase

  scope :with_known_teams, -> { where.not(team_a: nil, team_b: nil) }
  scope :with_known_goals, -> { where.not(goals_a: nil, goals_b: nil) }
  scope :bettable, -> { with_known_teams.not_locked }
  scope :scorable, -> { with_known_teams.with_known_goals.locked }

  # Returns the winner as a symbol `:team_a` or `:team_b` or `:draw` if it is a tie.
  def result
    return unless valid? && scorable?
    if goals_a == goals_b
      if drawable?
        :draw
      else
        penalty_goals_a > penalty_goals_b ? :team_a : :team_b
      end
    else
      goals_a > goals_b ? :team_a : :team_b
    end
  end

  def total_points
    (result_points + (2 * goal_points))
  end

  def result_points
    Integer(ENV.fetch('APP_MATCH_POINTS_RESULT', 6))
  end

  def goal_points
    Integer(ENV.fetch('APP_MATCH_POINTS_GOALS', 2))
  end

  # TODO spec
  def played?
    self.played_at < Time.zone.now &&
    self.with_known_goals? &&
      self.with_known_teams?
  end

  # TODO spec
  def drawable?
    self.round? && self.round == 'group'
  end

  # A match is bettable up to hours_before_start_time_to_bet hour before it starts,
  # and must have both teams known.
  def bettable?
    self.with_known_teams? && !self.locked?
  end

  def with_known_teams?
    self.team_a.present? && self.team_b.present?
  end

  # TODO spec
  def with_known_goals?
    self.goals_a.present? && self.goals_b.present?
  end

  # TODO spec
  def betted_by?(bet)
    bet.matches.exists?(id: self.id)
  end

  def played_on_text
    return nil unless self.played_on?
    VENUES[self.played_on]
  end

  # TODO spec
  def self.all_bettables_in_order
    self.ordered.with_known_teams.all
  end

  # Returns `true` if the match is ready to be scored.
  # TODO spec
  def scorable?
    with_known_teams? &&
      with_known_goals? &&
      locked?
  end

  private

  # validation
  def teams_are_not_the_same
    if with_known_teams? &&
      self.team_a == self.team_b
      errors.add(:team_b_id, :equal_teams)
    end
  end

  # validation
  def teams_must_be_of_the_same_group_as_the_match
    if with_known_teams? &&
      self.group? &&
      [self.group, self.team_a.group, self.team_b.group].uniq.size != 1
      errors.add(:group, :not_the_same)
    end
  end

  # validation
  def no_draw_after_group_phase
    return unless with_known_teams? && with_known_goals? && !drawable?
    if goals_draw?
      if !with_known_penalty_goals?
        errors.add(:penalty_goals_a, :blank)
        errors.add(:penalty_goals_b, :blank)
      end
      if penalty_goals_draw?
        errors.add(:penalty_goals_b, :equal)
      end
    end
  end

  def goals_draw?
    with_known_goals? && self.goals_a == self.goals_b
  end

  def with_known_penalty_goals?
    self.penalty_goals_a.present? && self.penalty_goals_b.present?
  end

  def penalty_goals_draw?
    with_known_penalty_goals? && self.penalty_goals_a == self.penalty_goals_b
  end

  def update_match_bets
    # TODO: move it into an async event
    MatchBetScore.update(self) if played?
    true
  end

end
