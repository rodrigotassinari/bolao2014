class Question < ActiveRecord::Base
  include BettableEvent

  ANSWER_TYPES = %w( team player boolean )

  has_many :question_bets

  validates :body_en,
    presence: true,
    uniqueness: { case_insensitive: true }

  validates :body_pt,
    presence: true,
    uniqueness: { case_insensitive: true }

  validates :answer_type,
    presence: true,
    inclusion: { in: ANSWER_TYPES, allow_blank: true }

  validate :answer_must_match_answer_type

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

  # TODO spec
  def answered?
    self.played_at < Time.zone.now &&
      self.answer.present?
  end

  # A question is bettable up to hours_before_start_time_to_bet hour before it starts.
  def bettable?
    !self.locked?
  end

  # TODO spec
  def betted_by?(bet)
    bet.questions.exists?(id: self.id)
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
