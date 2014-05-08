class User < ActiveRecord::Base

  EMAIL_REGEX = /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  PASSWORD_EXPIRATION_MINUTES = 15

  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: EMAIL_REGEX, allow_blank: true }

  validates :name,
    uniqueness: { case_sensitive: false },
    allow_blank: true

  validates :time_zone,
    presence: true,
    inclusion: { in: ActiveSupport::TimeZone.all.map(&:name), allow_blank: true }

  validates :locale,
    presence: true,
    inclusion: { in: I18n.available_locales.map(&:to_s), allow_blank: true }

  validates :remember_me_token,
    presence: { on: :update }, # on create we now it's there
    uniqueness: { case_sensitive: true, allow_blank: true }

  validates :authentication_token,
    uniqueness: { case_sensitive: true, allow_blank: true }

  before_create :set_remember_me_token

  # TODO spec
  def email_with_name
    if self.name.present?
      "#{self.name} <#{self.email}>"
    else
      self.email
    end
  end

  # TODO spec
  def name_or_email
    self.name.present? ? self.name : self.email
  end

  def authentication_token_exists?
    self.authentication_token.present? && self.authentication_token_expires_at.present?
  end

  def generate_authentication_token!
    clear_text_token = non_ambiguous_token(8)
    expiration = (Time.zone.now + PASSWORD_EXPIRATION_MINUTES.minutes)
    self.authentication_token_expires_at = expiration
    self.authentication_token = BCrypt::Password.create(authentication_token_input(clear_text_token)).to_s
    self.save!
    clear_text_token
  end

  def authentication_token_expired?
    raise RuntimeError.new, 'authentication_token not set' unless authentication_token_exists?
    self.authentication_token_expires_at < Time.zone.now
  end

  def validate_authentication_token!(clear_text_token)
    return false unless authentication_token_exists?
    result = !authentication_token_expired? &&
      BCrypt::Password.new(self.authentication_token) == authentication_token_input(clear_text_token)
    reset_authentication_token!
    result
  end

  def set_defaults
    self.locale = I18n.locale.to_s
    self.time_zone = Time.zone.name
  end

  private

  def reset_authentication_token!
    self.authentication_token_expires_at = nil
    self.authentication_token = nil
    self.save!
  end

  def authentication_token_input(clear_text_token)
    [
      self.email,
      clear_text_token,
      self.authentication_token_expires_at.to_i
    ].reject(&:blank?).join('--')
  end

  # before_create
  def set_remember_me_token
    begin
      self.remember_me_token = SecureRandom.urlsafe_base64
    end while User.exists?(remember_me_token: self.remember_me_token)
  end

  # Generates a random string from a set of easily readable characters
  def non_ambiguous_token(length=8)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z }
    (0...length).map { charset.to_a[SecureRandom.random_number(charset.size)] }.join
  end

end
