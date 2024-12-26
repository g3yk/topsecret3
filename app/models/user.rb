class User < ApplicationRecord
  # Ensures that the password is securely hashed and stored
  has_secure_password

  # Callback to downcase the email before saving the record
  before_save :downcase_email

  # Virtual attribute to hold the current password
  attr_accessor :current_password

  # Associations: a user can follow other users
  has_many :followships, foreign_key: :follower_id, dependent: :destroy
  has_many :followings, through: :followships, source: :following
  has_many :reverse_followships, foreign_key: :following_id, class_name: "Followship", dependent: :destroy
  has_many :followers, through: :reverse_followships, source: :follower

  # Associations: a user can have many posts and notifications
  has_many :posts
  has_many :notifications, foreign_key: :user_target_id, dependent: :destroy

  # Association: a user belongs to a country
  belongs_to :country # , optional: true

  # User can upload an avatar image
  has_one_attached :avatar

  # Validations:
  # Ensures the email is correctly formatted, present, unique, and within length limits
  validates :email,
    format: {
      with: URI::MailTo::EMAIL_REGEXP
    },
    presence: true, uniqueness: true,
    length: {
      maximum: 100
    }

  # Ensures the username is present, unique, within length limits, and only contains letters, numbers, and underscores
  validates :username, presence: true, uniqueness: true,
    length: {
      minimum: 5, maximum: 20
    },
    format: {
      with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers, and underscores"
    }

  # Ensures the phone number is correctly formatted when updating
  validates :phone, presence: true,
    format: {
      with: /\A\+\d{1,4} \d{10}\z/, message: "must be in the format: +1 XXXXXXXXXX"
    },
    on: :update

  # Custom validation to prevent changes to the username and email after creation
  validate :prevent_username_and_email_change, on: :update

  # Custom validation to check the avatar's mime type
  validate :correct_avatar_mime_type

  # Follow a user if not already following
  def follow(user)
    followings << user unless following?(user)
  end

  # Unfollow a user
  def unfollow(user)
    followships.find_by(following_id: user.id)&.destroy
  end

  # Check if the user is following another user
  def following?(user)
    followings.include?(user)
  end

  private

  # Prevent changes to username or email after account creation
  def prevent_username_and_email_change
    if username_changed? || email_changed?
      errors.add(:base, "You cannot change your username or email.")
    end
  end

  # Ensure the avatar is a PNG, JPG, or JPEG image
  def correct_avatar_mime_type
    if avatar.attached?
      allowed_types = %w[image/png image/jpg image/jpeg]
      unless avatar.content_type.in?(allowed_types)
        errors.add(:avatar, "must be a PNG, JPG or JPEG file")
      end
    end
  end

  # Convert email to lowercase before saving
  def downcase_email
    self.email = email.downcase
  end
end
