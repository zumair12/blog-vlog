# frozen_string_literal: true

class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  COLORS = %w[#6366f1 #8b5cf6 #ec4899 #f43f5e #f97316 #eab308 #22c55e #14b8a6 #06b6d4 #3b82f6].freeze


  # Associations
  has_many :posts, dependent: :nullify

  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 2, maximum: 50 }
  validates :color, presence: true, format: { with: /\A#[0-9a-fA-F]{6}\z/, message: "must be a valid hex color" }
  validates :icon, presence: true

  # Scopes
  scope :with_published_posts, -> { joins(:posts).where(posts: { status: :published }).distinct }
  scope :ordered, -> { order(:name) }
  scope :popular, -> { order(posts_count: :desc) }

  def should_generate_new_friendly_id?
    name_changed? || slug.blank?
  end

  def to_s
    name
  end
end
