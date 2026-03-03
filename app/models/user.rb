# frozen_string_literal: true

class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  # Roles
  enum :role, { reader: 0, author: 1, admin: 2 }, prefix: true

  # Associations
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :avatar

  # Scopes
  scope :authors, -> { where(role: [ :author, :admin ]) }
  scope :admins, -> { where(role: :admin) }
  scope :recent, -> { order(created_at: :desc) }

  # Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       length: { minimum: 3, maximum: 30 },
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only letters, numbers, and underscores" }
  validates :bio, length: { maximum: 500 }, allow_blank: true
  validates :website, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }, allow_blank: true

  # Callbacks
  before_validation :downcase_username

  # Instance methods
  def display_name
    username.presence || email.split("@").first
  end

  def full_display_name
    username
  end

  def avatar_url
    if avatar.attached?
      avatar
    else
      nil
    end
  end

  def initials
    username.first(2).upcase
  end

  def published_posts_count
    posts.published.count
  end

  private

  def downcase_username
    self.username = username&.downcase
  end
end
