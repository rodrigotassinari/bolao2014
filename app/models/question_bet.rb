class QuestionBet < ActiveRecord::Base
  include EventBet

  belongs_to :question
  alias_method :event, :question

  validates :question,
    presence: true

  validates :answer,
    presence: true

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

  def next_question_to_bet
    self.next_event_to_bet
  end

  # validate
  def answer_must_match_answer_type
    return unless (self.answer.present? && self.question.present?)
    self.send("answer_must_match_answer_type_#{self.question.answer_type}")
  end

  def answer_must_match_answer_type_team
    errors.add(:answer, :invalid) unless (Team.count > 0 && Team.where(id: Integer(self.answer)).count == 1)
  end

  def answer_must_match_answer_type_player
    errors.add(:answer, :invalid) unless (Player.count > 0 && Player.where(id: Integer(self.answer)).count == 1)
  end

  def answer_must_match_answer_type_boolean
    errors.add(:answer, :invalid) unless ['true', 'false'].include?(self.answer)
  end

end
