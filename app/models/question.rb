class Question < ActiveRecord::Base

  ANSWER_TYPES = %w( team player boolean )
  # How long (in hours) to allow bets on a question
  HOURS_BEFORE_START_TIME_TO_BET = 1

  has_many :question_bets

  validates :number,
    presence: true,
    uniqueness: true

  validates :body_en,
    presence: true,
    uniqueness: { case_insensitive: true }

  validates :body_pt,
    presence: true,
    uniqueness: { case_insensitive: true }

  validates :played_at,
    presence: true

  validates :answer_type,
    presence: true,
    inclusion: { in: ANSWER_TYPES, allow_blank: true }

  validate :answer_must_match_answer_type

  scope :ordered, -> { order(played_at: :asc, id: :asc) }
  scope :locked, -> { where('questions.played_at <= ?', HOURS_BEFORE_START_TIME_TO_BET.hour.from_now) }
  scope :not_locked, -> { where('questions.played_at > ?', HOURS_BEFORE_START_TIME_TO_BET.hour.from_now) }
  scope :bettable, -> { not_locked }

  def body
    self.send("body_#{I18n.locale}".to_sym)
  end

  def answer_object
    return if self.answer.blank?
    case self.answer_type
    when 'team'
      Team.find(Integer(self.answer))
    when 'player'
      Player.find(Integer(self.answer))
    when 'boolean'
      self.answer == 'true'
    end
  end

  def total_points
    kind = "APP_QUESTION_POINTS_#{answer_type.upcase}"
    Integer(ENV.fetch(kind, 5))
  end

  # A question is locked for betting HOURS_BEFORE_START_TIME_TO_BET hour before it starts.
  def locked?
    self.played_at <= HOURS_BEFORE_START_TIME_TO_BET.hour.from_now
  end

  # A question is bettable up to HOURS_BEFORE_START_TIME_TO_BET hour before it starts.
  def bettable?
    !self.locked?
  end

  # TODO spec
  def bettable_until
    self.played_at - HOURS_BEFORE_START_TIME_TO_BET.hour
  end

  # TODO spec
  def betted_by?(bet)
    bet.questions.exists?(id: self.id)
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

  # TODO spec
  def self.all_bettables_in_order
    self.ordered.all
  end

  # TODO spec
  def possible_answers
    case self.answer_type
    when 'team'
      Team.unscoped.order(acronym: :asc)
    when 'player'
      base_relation = Player.joins(:team).includes(:team).order('teams.acronym ASC, players.position DESC, players.name ASC')
      if self.answer_scope
        base_relation.where(self.answer_scope)
      else
        base_relation
      end
    when 'boolean'
      ['true', 'false']
    end
  end

  private

  def answer_must_match_answer_type
    if !self.answer.blank? && !self.answer_type.blank?
      case self.answer_type
      when 'team'
        errors.add(:answer, :invalid) unless (Team.count > 0 && Team.where(id: Integer(self.answer)).count == 1)
      when 'player'
        errors.add(:answer, :invalid) unless (Player.count > 0 && Player.where(id: Integer(self.answer)).count == 1)
      when 'boolean'
        errors.add(:answer, :invalid) unless ['true', 'false'].include?(self.answer)
      end
    end
  end

end
