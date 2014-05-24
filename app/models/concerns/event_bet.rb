module EventBet
  extend ActiveSupport::Concern

  included do
    belongs_to :bet

    validates :bet,
      presence: true

    validates :points,
      presence: true,
      numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

    scope :scored, -> { where.not(:points, nil) }
  end

  module ClassMethods
  end

  def next_event_to_bet
    self.bet.
      send("bettable_#{self.event.class.to_s.downcase.underscore.pluralize}_still_to_bet").
      where.not(number: self.event.number).
      order(number: :asc).limit(1).first
  end

  # TODO spec
  def scored?
    !self.points.nil?
  end

end
