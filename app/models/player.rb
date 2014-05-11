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

end
