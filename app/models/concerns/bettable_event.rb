module BettableEvent
  extend ActiveSupport::Concern

  included do
    # How long (in hours) to allow bets on an event
    class_attribute :hours_before_start_time_to_bet
    self.hours_before_start_time_to_bet = 1

    validates :number,
      presence: true,
      uniqueness: true

    validates :played_at,
      presence: true

    scope :ordered, -> { order(played_at: :asc, number: :asc) }
    scope :locked, -> { where('played_at <= ?', hours_before_start_time_to_bet.hour.from_now) }
    scope :not_locked, -> { where('played_at > ?', hours_before_start_time_to_bet.hour.from_now) }
  end

  module ClassMethods
    # TODO spec
    def all_in_order
      self.ordered.all
    end
  end

  # An event is locked for betting hours_before_start_time_to_bet hour before it starts.
  def locked?
    self.played_at <= self.class.hours_before_start_time_to_bet.hour.from_now
  end

  # TODO spec
  def bettable_until
    self.played_at - self.class.hours_before_start_time_to_bet.hour
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

  # Score all existing [match/question]_bets for this [match/question] (calculates the points
  # and saves on the [match/question]_bets). Can be run any number of times.
  #
  # TODO run it automatically the first time the [match/question] is updated with it's real
  # results (goals & who won for match, answer for question).
  def score!
    "#{self.class}Scorer".constantize.new(self).score_all!
  end

end
