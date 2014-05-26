class Bet < ActiveRecord::Base

  belongs_to :user
  has_many :match_bets
  has_many :question_bets
  has_many :matches, through: :match_bets
  has_many :questions, through: :question_bets
  has_one :payment

  validates :user,
    presence: true

  validates :points,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  def cost
    BigDecimal(ENV.fetch('APP_BET_COST', 25))
  end

  def to_prize
    BigDecimal(ENV.fetch('APP_BET_PRIZE', 20))
  end

  def payment_deadline
    Match.where(round: 'round_16').ordered.first.played_at
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
    self.payment && self.payment.paid?
  end

  # TODO spec
  def paying?
    self.payment && self.payment.paying?
  end

  # TODO spec
  def match_bets_percentage
    bettable_count = Match.bettable.count
    return 0.0 if bettable_count == 0
    (self.match_bets.count / bettable_count.to_f) * 100.0
  end
  # TODO spec
  def question_bets_percentage
    bettable_count = Question.bettable.count
    return 0.0 if bettable_count == 0
    (self.question_bets.count / bettable_count.to_f) * 100.0
  end
  # TODO spec
  def percentage
    bettable_count = (Match.bettable.count + Question.bettable.count)
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

  def filtered_question_bets(filter=nil)
    case filter.to_s
    when 'to_bet'
      self.question_bets.where('1=2')
    else
      self.question_bets.unscoped
    end
  end

  def filtered_match_bets(filter=nil)
    case filter.to_s
    when 'to_bet'
      self.match_bets.where('1=2')
    else
      self.match_bets.unscoped
    end
  end

end
