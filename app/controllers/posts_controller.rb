# frozen_string_literal: true

class PostsController < ApplicationController
  def index
    @posts = Post.status_published
                 .with_all_associations
                 .recent
                 .page(params[:page])
                 .per(9)

    @featured_posts  = Post.status_published.featured.with_all_associations.recent.limit(3)
    @categories      = Category.with_published_posts.ordered
    @popular_tags    = Tag.popular.limit(10)

    set_meta_tags(
      title: "Home",
      description: "Discover stories, ideas, and expertise from our community of writers."
    )
  end

  def show
    @post = Post.status_published.friendly.find(params[:slug])
    @post.increment_views!

    @comments     = @post.approved_comments.includes(:user, replies: :user)
    @comment      = Comment.new
    @related_posts = @post.related_posts(limit: 3)

    set_meta_tags(
      title: @post.title,
      description: @post.excerpt,
      og: {
        title: @post.title,
        description: @post.excerpt,
        type: "article",
        image: @post.featured_image.attached? ? url_for(@post.featured_image) : nil
      }
    )
  end

  def archive
    @posts_by_year = Post.status_published
                         .order(published_at: :desc)
                         .group_by { |p| p.published_at.year }

    set_meta_tags(title: "Archive", description: "Browse all posts by year.")
  end
end
