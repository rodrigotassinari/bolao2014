class MatchBet < ActiveRecord::Base

  belongs_to :bet
  belongs_to :match

  validates :bet,
    presence: true

  validates :match,
    presence: true

  validates :points,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  validates :goals_a,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  validates :goals_b,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  validate :no_draws_after_groups_phase

  def next_match_to_bet
    self.bet.
      bettable_matches_still_to_bet.
      where.not(number: self.match.number).
      order(number: :asc).limit(1).first
  end

  private

  # validate
  def no_draws_after_groups_phase
    if self.match &&
      self.match.round != 'group' &&
      self.goals_b == self.goals_b &&
      self.penalty_winner_id.blank?
      errors.add(:penalty_winner_id, :blank)
    end
  end

end
