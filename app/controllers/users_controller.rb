# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user  = User.find_by!(username: params[:username])
    @posts = @user.posts
                  .status_published
                  .with_all_associations
                  .recent
                  .page(params[:page])
                  .per(9)

    set_meta_tags(
      title: "@#{@user.username}",
      description: @user.bio.presence || "Blog posts by #{@user.username}"
    )
  end
end
