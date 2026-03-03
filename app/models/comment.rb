# frozen_string_literal: true

class Comment < ApplicationRecord
  # Associations
  belongs_to :post, counter_cache: true
  belongs_to :user
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy

  # Enums
  enum :status, { pending: 0, approved: 1, rejected: 2, spam: 3 }, prefix: true

  # Scopes
  scope :top_level, -> { where(parent_id: nil) }
  scope :approved, -> { where(status: :approved) }
  scope :pending_review, -> { where(status: :pending).order(created_at: :desc) }
  scope :recent, -> { order(created_at: :desc) }
  scope :with_replies, -> { includes(replies: :user) }

  # Validations
  validates :body, presence: true, length: { minimum: 2, maximum: 2000 }

  # Callbacks
  after_create :notify_post_author
  after_update :notify_on_approval

  def reply?
    parent_id.present?
  end

  def top_level?
    parent_id.nil?
  end

  delegate :username, to: :user, prefix: true

  private

  def notify_post_author
    # Future: PostMailer.comment_notification(self).deliver_later if post.user != user
  end

  def notify_on_approval
    # Future: trigger notification when status changes to approved
  end
end
