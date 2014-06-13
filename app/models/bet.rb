class Bet < ActiveRecord::Base

  belongs_to :user
  has_one :payment, dependent: :destroy
  has_many :match_bets, dependent: :destroy
  has_many :question_bets, dependent: :destroy
  has_many :matches, through: :match_bets
  has_many :questions, through: :question_bets

  validates :user,
    presence: true

  validates :points,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  def score
    match_bets.sum(:points) + question_bets.sum(:points)
  end

  # TODO spec
  def score!
    self.update_attributes!(points: self.score)
  end

  def cost
    BigDecimal(ENV.fetch('APP_BET_COST', 25))
  end

  def to_prize
    BigDecimal(ENV.fetch('APP_BET_PRIZE', 20))
  end

  def payment_deadline
    Time.zone.parse('2014-06-12 17:00:00 -0300')
  end

  def prize_split
    {
      first: Float(ENV.fetch('APP_PRIZE_FIRST', 65.0)),
      second: Float(ENV.fetch('APP_PRIZE_SECOND', 25.0)),
      third: Float(ENV.fetch('APP_PRIZE_THIRD', 10.0)),
    }
  end

  # TODO spec
  def paid?
    self.payment.present? && self.payment.paid?
  end

  # TODO spec
  def paying?
    self.payment.present? && self.payment.paying?
  end

  # TODO spec
  def match_bets_percentage
    bettable_count = Match.with_known_teams.count
    return 0.0 if bettable_count == 0
    (self.match_bets.count / bettable_count.to_f) * 100.0
  end
  # TODO spec
  def question_bets_percentage
    bettable_count = Question.count
    return 0.0 if bettable_count == 0
    (self.question_bets.count / bettable_count.to_f) * 100.0
  end
  # TODO spec
  def percentage
    bettable_count = (Match.with_known_teams.count + Question.count)
    return 0.0 if bettable_count == 0
    ((self.match_bets.count + self.question_bets.count) / bettable_count.to_f) * 100.0
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

  # TODO spec
  def filtered_matches(filter=nil)
    case filter.to_s
    when 'betted'
      self.matches.ordered
    when 'to_bet'
      self.bettable_matches_still_to_bet
    else
      Match.with_known_teams.ordered
    end
  end

  # TODO spec
  def filtered_questions(filter=nil)
    case filter.to_s
    when 'betted'
      self.questions.ordered
    when 'to_bet'
      self.bettable_questions_still_to_bet
    else
      Question.unscoped.ordered
    end
  end

  # TODO spec
  def filtered_question_bets(filter=nil)
    case filter.to_s
    when 'to_bet'
      self.question_bets.where('1=2')
    else
      self.question_bets.scope
    end
  end

  # TODO spec
  def filtered_match_bets(filter=nil)
    case filter.to_s
    when 'to_bet'
      self.match_bets.where('1=2')
    else
      self.match_bets.scope
    end
  end

end
