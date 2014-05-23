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

  # TODO spec
  def next_to_bet
    self.bet.
      send("bettable_#{self.class.to_s.downcase.underscore.pluralize}_still_to_bet").
      where.not(number: self.send(self.to_s.downcase.underscore).number).
      order(number: :asc).limit(1).first
  end

  def scored?
    !self.points.nil?
  end

end
