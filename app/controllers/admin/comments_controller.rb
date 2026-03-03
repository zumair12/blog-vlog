# frozen_string_literal: true

class Admin::CommentsController < Admin::BaseController
  before_action :set_comment, only: %i[show update destroy approve reject mark_spam]

  def index
    @comments = Comment.includes(:post, :user, :parent)
                       .order(created_at: :desc)
                       .page(params[:page])
                       .per(20)

    @comments = @comments.status_pending   if params[:status] == "pending"
    @comments = @comments.status_approved  if params[:status] == "approved"
    @comments = @comments.status_rejected  if params[:status] == "rejected"
    @comments = @comments.status_spam      if params[:status] == "spam"
  end

  def show; end

  def update
    @comment.update(comment_params)
    redirect_to admin_comment_path(@comment), notice: "Comment updated."
  end

  def destroy
    @comment.destroy
    redirect_to admin_comments_path, notice: "Comment deleted."
  end

  def approve
    @comment.status_approved!
    respond_to do |format|
      format.html { redirect_back fallback_location: admin_comments_path, notice: "Comment approved." }
      format.turbo_stream
    end
  end

  def reject
    @comment.status_rejected!
    respond_to do |format|
      format.html { redirect_back fallback_location: admin_comments_path, notice: "Comment rejected." }
      format.turbo_stream
    end
  end

  def mark_spam
    @comment.status_spam!
    respond_to do |format|
      format.html { redirect_back fallback_location: admin_comments_path, notice: "Comment marked as spam." }
      format.turbo_stream
    end
  end

  def bulk_approve
    Comment.where(id: params[:comment_ids]).update_all(status: :approved)
    redirect_to admin_comments_path, notice: "Comments approved."
  end

  def bulk_reject
    Comment.where(id: params[:comment_ids]).update_all(status: :rejected)
    redirect_to admin_comments_path, notice: "Comments rejected."
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :status)
  end
end
