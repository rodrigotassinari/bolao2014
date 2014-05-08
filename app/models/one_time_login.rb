# TODO translate class, attributes and errors
class OneTimeLogin

  extend ActiveModel::Translation

  attr_reader :user, :errors

  def initialize(user)
    @user = user
    @errors = ActiveModel::Errors.new(self)
  end

  def valid?
    validate!
    errors.empty?
  end

  def send_authentication_check!
    if valid?
      token = user.generate_authentication_token!
      true
    else
      false
    end
  end

  def self.find_user(email)
    user = User.find_or_initialize_by(email: email)
    return user if user.persisted?
    user.set_defaults
    user
  end

  # The following methods are needed to ActiveModel::Errors be minimally implemented
  def read_attribute_for_validation(attr)
    send(attr)
  end
  # End minimal ActiveModel::Errors methods

  private

  def validate!
    if user.present?
      errors.add(:user, "is invalid") if !user.valid?
    else
      errors.add(:user, "cannot be nil")
    end
  end

end
