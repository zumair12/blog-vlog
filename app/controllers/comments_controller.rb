# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to post_path(@post.slug), notice: "Comment submitted for review."
    else
      redirect_to post_path(@post.slug), alert: @comment.errors.full_messages.to_sentence
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    authorize @comment

    @comment.destroy
    redirect_to post_path(@post.slug), notice: "Comment deleted."
  end

  private

  def set_post
    @post = Post.status_published.friendly.find(params[:post_slug])
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end
end
