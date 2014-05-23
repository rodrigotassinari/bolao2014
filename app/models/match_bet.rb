class MatchBet < ActiveRecord::Base
  include EventBet

  belongs_to :match

  validates :match,
    presence: true

  validates :goals_a,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  validates :goals_b,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  validate :no_draws_after_groups_phase

  validate :no_penalty_winner_during_groups_phase

  validate :no_penalty_winner_after_groups_phase_if_no_draw

  # TODO spec
  def next_match_to_bet
    self.next_to_bet
  end

  private

  # validate
  def no_draws_after_groups_phase
    if self.match &&
      !self.match.drawable? &&
      self.goals_a == self.goals_b &&
      self.penalty_winner_id.blank?
      errors.add(:penalty_winner_id, :blank)
    end
  end

  def no_penalty_winner_after_groups_phase_if_no_draw
    if self.match &&
      !self.match.drawable? &&
      self.goals_a != self.goals_b &&
      self.penalty_winner_id.present?
      errors.add(:penalty_winner_id, :present)
    end
  end

  def no_penalty_winner_during_groups_phase
    if self.match &&
      self.match.drawable? &&
      self.penalty_winner_id.present?
      errors.add(:penalty_winner_id, :present)
    end
  end

end
