# frozen_string_literal: true

class Admin::PostsController < Admin::BaseController
  before_action :set_post, only: %i[show edit update destroy publish archive feature unfeature]

  def index
    @posts = policy_scope(Post)
               .with_all_associations
               .order(created_at: :desc)
               .page(params[:page])
               .per(15)

    # Filters
    @posts = @posts.status_published  if params[:status] == "published"
    @posts = @posts.status_draft      if params[:status] == "draft"
    @posts = @posts.status_archived   if params[:status] == "archived"
    @posts = @posts.where(category: Category.find_by(slug: params[:category])) if params[:category].present?
    @posts = @posts.where("posts.title ILIKE ?", "%#{params[:q]}%") if params[:q].present?
  end

  def show; end

  def new
    @post = Post.new
    @categories = Category.ordered
    @tags = Tag.ordered
    authorize @post
  end

  def create
    @post = current_user.posts.build(post_params)
    authorize @post

    if @post.save
      redirect_to admin_post_path(@post), notice: "Post created successfully."
    else
      @categories = Category.ordered
      @tags = Tag.ordered
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.ordered
    @tags = Tag.ordered
    authorize @post
  end

  def update
    authorize @post

    if @post.update(post_params)
      redirect_to admin_post_path(@post), notice: "Post updated successfully."
    else
      @categories = Category.ordered
      @tags = Tag.ordered
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post
    @post.destroy
    redirect_to admin_posts_path, notice: "Post deleted."
  end

  def publish
    authorize @post
    @post.update!(status: :published)
    redirect_back fallback_location: admin_posts_path, notice: "Post published."
  end

  def archive
    authorize @post
    @post.update!(status: :archived)
    redirect_back fallback_location: admin_posts_path, notice: "Post archived."
  end

  def feature
    authorize @post
    @post.update!(featured: true)
    redirect_back fallback_location: admin_posts_path, notice: "Post featured."
  end

  def unfeature
    authorize @post
    @post.update!(featured: false)
    redirect_back fallback_location: admin_posts_path, notice: "Post unfeatured."
  end

  private

  def set_post
    @post = Post.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(
      :title, :excerpt, :status, :category_id, :featured,
      :featured_image, :tag_list, :content
    )
  end
end
