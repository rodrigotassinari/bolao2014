class Bet < ActiveRecord::Base

  belongs_to :user
  has_many :match_bets
  has_many :question_bets
  has_many :matches, through: :match_bets
  has_many :questions, through: :question_bets

  validates :user,
    presence: true

  validates :points,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  # TODO spec
  # TODO move to presenter?
  def match_bets_percentage
    bettable_count = Match.bettable.count
    return 0.0 if bettable_count == 0
    ((self.match_bets.count / bettable_count.to_f) * 100.0).round(2)
  end

  def matches_still_to_bet
    self.matches.where.not(id: self.matches.pluck(:id))
  end

  def bettable_matches
    Match.bettable.ordered
  end

  def bettable_matches_still_to_bet
    self.bettable_matches.where.not(id: self.matches.pluck(:id))
  end

  def bettable_matches_already_betted
    self.matches.bettable.ordered
  end

  def bettable_questions
    Question.bettable.ordered
  end

  def bettable_questions_still_to_bet
    Question.bettable.ordered.where.not(id: self.questions.pluck(:id))
  end

  def bettable_questions_already_betted
    self.questions.bettable.ordered
  end

end
