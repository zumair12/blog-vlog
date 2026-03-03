# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    @categories = Category.with_published_posts.includes(:posts).ordered

    set_meta_tags(title: "Categories", description: "Browse posts by category.")
  end

  def show
    @category = Category.friendly.find(params[:slug])
    @posts = @category.posts
                      .status_published
                      .with_all_associations
                      .recent
                      .page(params[:page])
                      .per(9)

    set_meta_tags(
      title: "#{@category.name} – Category",
      description: @category.description.presence || "Explore all posts in #{@category.name}."
    )
  end
end
