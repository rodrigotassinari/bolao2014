class Team < ActiveRecord::Base

  validates :name_en,
    presence: true,
    uniqueness: true

  validates :name_pt,
    presence: true,
    uniqueness: true

  validates :acronym,
    presence: true,
    uniqueness: true

  def name
    self.send("name_#{I18n.locale}".to_sym)
  end

end
