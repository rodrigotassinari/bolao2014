class User < ActiveRecord::Base

  EMAIL_REGEX = /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i

  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: EMAIL_REGEX }

  validates :name,
    uniqueness: { case_sensitive: false },
    allow_blank: true

  validates :time_zone,
    presence: true,
    inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }

  validates :locale,
    presence: true,
    inclusion: { in: I18n.available_locales.map(&:to_s) }

  validates :remember_me_token,
    presence: { on: :update }, # on create we now it's there
    uniqueness: { case_sensitive: true }

  validates :authentication_token,
    uniqueness: { case_sensitive: true },
    allow_blank: true

  before_create :set_remember_me_token

  def generate_authentication_token!
    unique_attribute_value(:authentication_token, :non_ambiguous_token)
    self.authentication_token_expires_at = (Time.zone.now + 15.minutes)
    self.save!
  end

  private

  # before_create
  def set_remember_me_token
    unique_attribute_value(:remember_me_token, :big_url_safe_token)
  end

  # Generates a large random string from a set of url-safe characters
  def big_url_safe_token
    SecureRandom.urlsafe_base64
  end

  # Generates a random string from a set of easily readable characters
  def non_ambiguous_token(length=8)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z }
    (0...length).map { charset.to_a[SecureRandom.random_number(charset.size)] }.join
  end

  # Sets the value of `:column` to the return of `self.send(:method)` "guaranteeing" its uniqueness.
  def unique_attribute_value(column, method)
    begin
      self[column] = send(method)
    end while User.exists?(column => self[column])
  end

end
