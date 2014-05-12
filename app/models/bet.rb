class Bet < ActiveRecord::Base

  belongs_to :user
  has_many :match_bets
  has_many :question_bets

  validates :user,
    presence: true

  validates :points,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  # TODO spec
  def match_bets_percentage
    bettable_count = Match.bettable.count
    return 0.0 if bettable_count == 0
    ((self.match_bets.count / bettable_count.to_f) * 100.0).round(2)
  end

end
