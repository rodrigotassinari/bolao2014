class Match < ActiveRecord::Base

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
  # How long (in hours) to allow bets on a match
  HOURS_BEFORE_START_TIME_TO_BET = 1

  belongs_to :team_a, class_name: 'Team'
  belongs_to :team_b, class_name: 'Team'
  has_many :match_bets

  # belongs_to :winner, :class_name => 'Team' # TODO add winner_id to matches
  # belongs_to :loser, :class_name => 'Team' # TODO add loser_id to matches

  validates :number,
    presence: true,
    uniqueness: true

  validates :round,
    presence: true,
    inclusion: { in: ROUNDS, allow_blank: true }

  validates :group,
    inclusion: { in: GROUPS, allow_blank: true }

  validates :played_at,
    presence: true

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

  scope :ordered, -> { order(played_at: :asc, number: :asc) }
  scope :with_known_teams, -> { where.not(team_a: nil, team_b: nil) }
  scope :locked, -> { where('matches.played_at <= ?', HOURS_BEFORE_START_TIME_TO_BET.hour.from_now) }
  scope :not_locked, -> { where('matches.played_at > ?', HOURS_BEFORE_START_TIME_TO_BET.hour.from_now) }
  scope :bettable, -> { with_known_teams.not_locked }

  def total_points
    (result_points + (2 * goal_points))
  end

  def result_points
    Integer(ENV.fetch('APP_MATCH_POINTS_RESULT', 6))
  end

  def goal_points
    Integer(ENV.fetch('APP_MATCH_POINTS_GOALS', 2))
  end

  # A match is locked for betting HOURS_BEFORE_START_TIME_TO_BET hour before it starts.
  def locked?
    self.played_at <= HOURS_BEFORE_START_TIME_TO_BET.hour.from_now
  end

  # A match is bettable up to HOURS_BEFORE_START_TIME_TO_BET hour before it starts,
  # and must have both teams known.
  def bettable?
    self.with_known_teams? && !self.locked?
  end

  # TODO spec
  def bettable_until
    self.played_at - HOURS_BEFORE_START_TIME_TO_BET.hour
  end

  def with_known_teams?
    self.team_a.present? && self.team_b.present?
  end

  # TODO spec
  def next
    self.class.where('number > ?', self.number).order(number: :asc).limit(1).first
  end

  # TODO spec
  def next_bettable
    self.class.bettable.where('number > ?', self.number).order(number: :asc).limit(1).first
  end

  # TODO spec
  def previous
    self.class.where('number < ?', self.number).order(number: :desc).limit(1).first
  end

  # TODO spec
  def previous_bettable
    self.class.bettable.where('number < ?', self.number).order(number: :desc).limit(1).first
  end

  # TODO spec
  def any_other_bettable
    self.class.bettable.where.not(number: self.number).order(number: :asc).limit(1).first
  end

  def played_on_text
    return nil if self.played_on.blank?
    VENUES[self.played_on]
  end

  # TODO spec
  def self.all_in_order
    self.ordered.all
  end

  # TODO spec
  def self.all_bettables_in_order
    self.ordered.with_known_teams.all
  end

  private

  # validation
  def teams_are_not_the_same
    if self.team_a &&
      self.team_b &&
      self.team_a == self.team_b
      errors.add(:team_b_id, :equal_teams)
    end
  end

  # validation
  def teams_must_be_of_the_same_group_as_the_match
    if self.team_a &&
      self.team_b &&
      self.group &&
      [self.group, self.team_a.group, self.team_b.group].uniq.size != 1
      errors.add(:group, :not_the_same)
    end
  end

end
