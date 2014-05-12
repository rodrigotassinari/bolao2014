class Question < ActiveRecord::Base

  ANSWER_TYPES = %w( team player boolean )

  has_many :question_bets

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
