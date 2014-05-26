module EventBet
  extend ActiveSupport::Concern

  included do
    belongs_to :bet

    validates :bet,
      presence: true

    validates :points,
      presence: true,
      numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

    scope :scored, -> { where.not(points: nil, scored_at: nil) }
  end

  module ClassMethods
  end

  def next_event_to_bet
    self.bet.
      send("bettable_#{self.event.class.to_s.downcase.underscore.pluralize}_still_to_bet").
      where.not(number: self.event.number).
      order(number: :asc).limit(1).first
  end

  # Returns true if this event_bet is ready to be scored.
  def scorable?
    self.valid? && self.event.scorable?
  end

  # Returns true if this event_bet has been scored.
  def scored?
    self.scored_at? && self.points >= 0
  end

  # Calculates and saves points for this event_bet.
  def score!
    previous_points = self.points
    calculate_score
    self.save!
    current_points = self.points
    # TODO update / recalculate bet total points
    # notify user of the score
    notify_user_of_points_change(previous_points, current_points)
    true
  end

end
