# frozen_string_literal: true

class TagsController < ApplicationController
  def index
    @tags = Tag.popular

    set_meta_tags(title: "Tags", description: "Browse posts by tag.")
  end

  def show
    @tag   = Tag.friendly.find(params[:slug])
    @posts = @tag.posts
                 .status_published
                 .with_all_associations
                 .recent
                 .page(params[:page])
                 .per(9)

    set_meta_tags(
      title: "##{@tag.name} – Tag",
      description: "Explore all posts tagged with #{@tag.name}."
    )
  end
end
