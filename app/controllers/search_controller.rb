# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    @query = params[:q].to_s.strip

    if @query.length >= 2
      @posts = Post.status_published
                   .joins("LEFT JOIN action_text_rich_texts ON action_text_rich_texts.record_id = posts.id AND action_text_rich_texts.record_type = 'Post' AND action_text_rich_texts.name = 'content'")
                   .where(
                     "posts.title ILIKE :q OR posts.excerpt ILIKE :q OR action_text_rich_texts.body ILIKE :q",
                     q: "%#{@query}%"
                   )
                   .with_all_associations
                   .recent
                   .page(params[:page])
                   .per(10)
    else
      @posts = Post.none.page(1)
    end

    set_meta_tags(title: @query.present? ? "Search: #{@query}" : "Search")
  end
end
