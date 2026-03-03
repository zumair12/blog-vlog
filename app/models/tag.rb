# frozen_string_literal: true

class Tag < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  COLORS = %w[#6366f1 #8b5cf6 #ec4899 #f43f5e #f97316 #eab308 #22c55e #14b8a6 #06b6d4 #3b82f6].freeze

  # Associations
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 2, maximum: 30 }
  validates :color, presence: true, format: { with: /\A#[0-9a-fA-F]{6}\z/, message: "must be a valid hex color" }

  # Scopes
  scope :popular, -> { order(posts_count: :desc) }
  scope :ordered, -> { order(:name) }

  def should_generate_new_friendly_id?
    name_changed? || slug.blank?
  end

  def to_s
    name
  end
end
