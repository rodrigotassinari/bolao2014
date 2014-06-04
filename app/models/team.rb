class Team < ActiveRecord::Base

  has_many :matches_as_a, class_name: 'Match', foreign_key: 'team_a_id'
  has_many :matches_as_b, class_name: 'Match', foreign_key: 'team_b_id'
  # has_many :matches, class_name: 'Match', :finder_sql => 'SELECT * FROM matches WHERE (matches.team_a_id = #{id} OR matches.team_b_id = #{id})' # TODO

  # has_many :winning_matches, class_name: 'Match', foreign_key: 'winner_id' # TODO add winner_id to matches
  # has_many :losing_matches,  class_name: 'Match', foreign_key: 'loser_id' # TODO add loser_id to matches

  scope :ordered, -> { order(acronym: :asc) }

  has_many :players

  validates :name_en,
    presence: true,
    uniqueness: true

  validates :name_pt,
    presence: true,
    uniqueness: true

  validates :acronym,
    presence: true,
    uniqueness: true

  validates :group,
    presence: true,
    inclusion: { in: Match::GROUPS, allow_blank: true }

  def name
    self.send("name_#{I18n.locale}".to_sym)
  end

  # TODO spec
  def name_and_acronym
    "#{self.acronym} #{self.name}"
  end

end
