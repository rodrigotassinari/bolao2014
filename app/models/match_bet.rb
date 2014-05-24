class MatchBet < ActiveRecord::Base
  include EventBet

  belongs_to :match
  alias_method :event, :match

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

  def next_match_to_bet
    self.next_event_to_bet
  end

  # Returns the winner as a symbol `:team_a` or `:team_b` or `:draw` if it is a tie.
  def result
    return unless valid?
    if goals_a == goals_b
      if penalty_winner_id.present?
        penalty_winner_id == match.team_a.id ? :team_a : :team_b
      else
        :draw
      end
    else
      goals_a > goals_b ? :team_a : :team_b
    end
  end

  # Returns true if the match_bet result is correct (matches the match result). The
  # result is the winner of the match (or a draw).
  # TODO spec
  def correct_result?
    self.match.scorable? && self.result == self.match.result
  end

  # TODO spec
  def correct_goals_a?
    self.match.scorable? && self.goals_a == self.match.goals_a
  end

  # TODO spec
  def correct_goals_b?
    self.match.scorable? && self.goals_b == self.match.goals_b
  end

  # TODO spec
  def result_points
    correct_result? ? self.match.result_points : 0
  end

  # TODO spec
  def goals_a_points
    correct_goals_a? ? self.match.goal_points : 0
  end

  # TODO spec
  def goals_b_points
    correct_goals_b? ? self.match.goal_points : 0
  end

  # Calculates and saves points for this match_bet.
  #
  def score!
    calculate_score
    self.save!
    # TODO update / recalculate bet total points
    # TODO notify user (only if first time scoring / points changed)
    true
  end

  private

  def calculate_score
    raise 'match_bet is not scorable' unless scorable?
    self.points = 0
    self.points += result_points
    self.points += goals_a_points
    self.points += goals_b_points
    self.scored_at = Time.zone.now
  end

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
