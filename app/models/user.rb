class User < ActiveRecord::Base

  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i }
  validates :name,
    uniqueness: { case_sensitive: false },
    allow_blank: true
  validates :time_zone,
    presence: true,
    inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }
  validates :locale,
    presence: true,
    inclusion: { in: I18n.available_locales.map(&:to_s) }

end
