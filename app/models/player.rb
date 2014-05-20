class Player < ActiveRecord::Base

  POSITIONS = %w( field goalkeeper )

  belongs_to :team

  validates :team,
    presence: true

  validates :name,
    presence: true,
    uniqueness: { scope: :team_id }

  validates :position,
    presence: true,
    inclusion: { in: POSITIONS, allow_blank: true }

  scope :goalkeepers, -> { where(position: 'goalkeeper') }
  scope :fielders, -> { where(position: 'field') }

  def name_position_and_team
    [
      self.team.try(:acronym),
      self.name,
      (self.position == 'goalkeeper' ? "(#{translated_position})" : nil),
    ].reject(&:blank?).join(' ')
  end

  def translated_position
    I18n.t("activerecord.attributes.player.positions.#{self.position}")
  end

end
