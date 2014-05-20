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

  validate :no_penalty_winner_during_groups_phase

  validate :no_penalty_winner_after_groups_phase_if_no_draw

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
      self.goals_a == self.goals_b &&
      self.penalty_winner_id.blank?
      errors.add(:penalty_winner_id, :blank)
    end
  end

  def no_penalty_winner_after_groups_phase_if_no_draw
    if self.match &&
      self.match.round != 'group' &&
      self.goals_a != self.goals_b &&
      self.penalty_winner_id.present?
      errors.add(:penalty_winner_id, :present)
    end
  end

  def no_penalty_winner_during_groups_phase
    if self.match &&
      self.match.round == 'group' &&
      self.penalty_winner_id.present?
      errors.add(:penalty_winner_id, :present)
    end
  end

end
