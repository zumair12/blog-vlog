# frozen_string_literal: true

class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  # ActionText
  has_rich_text :content

  # Active Storage
  has_one_attached :featured_image

  # Associations
  belongs_to :user, counter_cache: true
  belongs_to :category, counter_cache: true, optional: true
  has_many :comments, dependent: :destroy
  has_many :approved_comments, -> { approved.top_level }, class_name: "Comment"
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  # Enums
  enum :status, { draft: 0, published: 1, archived: 2 }, prefix: true

  # Scopes
  scope :recent, -> { order(published_at: :desc, created_at: :desc) }
  scope :featured, -> { where(featured: true) }
  scope :popular, -> { order(views_count: :desc) }
  scope :with_all_associations, -> { includes(:user, :category, :tags, featured_image_attachment: :blob) }

  # Validations
  validates :title, presence: true, length: { minimum: 5, maximum: 200 }
  validates :excerpt, length: { maximum: 500 }, allow_blank: true
  validates :status, presence: true

  # Callbacks
  before_save :set_published_at
  before_save :calculate_reading_time
  before_save :generate_excerpt

  def should_generate_new_friendly_id?
    title_changed? || slug.blank?
  end

  def to_s
    title
  end

  def reading_time_text
    minutes = reading_time || 1
    "#{minutes} min read"
  end

  def increment_views!
    increment!(:views_count)
  end

  def tag_list
    tags.pluck(:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |name|
      Tag.find_or_create_by(name: name.strip.downcase) do |tag|
        tag.color = Tag::COLORS.sample
        tag.slug  = name.strip.downcase.parameterize
      end
    end
  end

  def next_post
    Post.status_published
        .where("published_at > ?", published_at)
        .order(published_at: :asc)
        .first
  end

  def previous_post
    Post.status_published
        .where("published_at < ?", published_at)
        .order(published_at: :desc)
        .first
  end

  def related_posts(limit: 3)
    Post.status_published
        .where(category: category)
        .where.not(id: id)
        .limit(limit)
  end

  private

  def set_published_at
    if status_published? && published_at.blank?
      self.published_at = Time.current
    end
  end

  def calculate_reading_time
    words = content&.to_plain_text&.split&.length || 0
    self.reading_time = [ (words / 200.0).ceil, 1 ].max
  end

  def generate_excerpt
    return if excerpt.present?

    plain = content&.to_plain_text.to_s
    self.excerpt = plain.strip.truncate(200) if plain.present?
  end
end
