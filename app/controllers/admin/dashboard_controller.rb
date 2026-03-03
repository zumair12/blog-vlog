# frozen_string_literal: true

class Admin::DashboardController < Admin::BaseController
  def index
    @stats = {
      total_posts:       Post.count,
      published_posts:   Post.status_published.count,
      draft_posts:       Post.status_draft.count,
      total_comments:    Comment.count,
      pending_comments:  Comment.status_pending.count,
      total_users:       User.count,
      total_categories:  Category.count,
      total_tags:        Tag.count,
      total_views:       Post.sum(:views_count)
    }

    @recent_posts    = Post.with_all_associations.recent.limit(5)
    @pending_comments = Comment.status_pending.includes(:post, :user).recent.limit(5)
    @popular_posts   = Post.status_published.popular.with_all_associations.limit(5)
    @recent_users    = User.recent.limit(5)

    # Chart data – posts per month for last 6 months
    @posts_chart_data = Post.status_published
                            .where(published_at: 6.months.ago..)
                            .group_by_month(:published_at)
                            .count rescue {}

    set_meta_tags(title: "Admin Dashboard")
  end

  def analytics
    @top_posts    = Post.status_published.popular.with_all_associations.limit(10)
    @top_categories = Category.popular.limit(5)
    @top_tags     = Tag.popular.limit(10)

    set_meta_tags(title: "Analytics")
  end
end
