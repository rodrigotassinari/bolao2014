class QuestionBet < ActiveRecord::Base

  belongs_to :bet
  belongs_to :question

  validates :bet,
    presence: true

  validates :question,
    presence: true

  validates :answer,
    presence: true

  validates :points,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  validate :answer_must_match_answer_type

  def answer_object
    return if self.answer.blank?
    case self.question.answer_type
    when 'team'
      Team.find(Integer(self.answer))
    when 'player'
      Player.find(Integer(self.answer))
    when 'boolean'
      self.answer == 'true'
    end
  end

  # TODO spec
  def next_question_to_bet
    self.bet.
      bettable_questions_still_to_bet.
      where.not(number: self.question.number).
      order(number: :asc).limit(1).first
  end

  private

  def answer_must_match_answer_type
    if self.answer.present? && self.question.present?
      case self.question.answer_type
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
