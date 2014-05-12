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
    'rj' => 'Maracanã - Estádio Jornalista Mário Filho, Rio de Janeiro, RJ',
    'rn' => 'Estadio das Dunas, Natal, RN',
    'rs' => 'Estádio Beira-Rio, Porto Alegre, RS',
    'sp' => 'Arena de São Paulo (Itaquerão), São Paulo, SP',
  }

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
  scope :bettable, -> { where.not(team_a: nil, team_b: nil) }

  def played_on_text
    return nil if self.played_on.blank?
    VENUES[self.played_on]
  end

  def self.all_bettables_in_order
    self.ordered.bettable.all
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
