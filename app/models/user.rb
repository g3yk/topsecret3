class User < ApplicationRecord
  has_secure_password
  before_save :downcase_email

  attr_accessor :current_password

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, uniqueness: true, length: { maximum: 100 }

  # validates :Username, presence: true, uniqueness: true, length: { maximum: 20 }
  # validates :Email, presence: true, uniqueness: true, length: { maximum: 100 }
  # validates :PhoneNumber, uniqueness: true, allow_nil: true

  # def password_digest
  #   BCrypt::Password.create(password)
  # end

  def downcase_email
    self.email = email.downcase
  end
end
