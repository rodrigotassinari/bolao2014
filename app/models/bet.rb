class Bet < ActiveRecord::Base

  belongs_to :user

  validates :user,
    presence: true

  validates :points,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

end
