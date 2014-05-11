class Question < ActiveRecord::Base

  ANSWER_TYPES = %w( team player boolean )

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

  def body
    self.send("body_#{I18n.locale}".to_sym)
  end

  private

  def answer_must_match_answer_type
    if self.answer && self.answer_type
      case self.answer_type
      when 'team'
        errors.add(:answer, :invalid) unless Team.pluck(:acronym).include?(self.answer)
      when 'player'
        # TODO
        # errors.add(:answer, :invalid) unless Player.pluck(:name).include?(self.answer)
      when 'boolean'
        errors.add(:answer, :invalid) unless ['true', 'false'].include?(self.answer)
      end
    end
  end

end
