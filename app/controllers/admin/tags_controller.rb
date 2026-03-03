# frozen_string_literal: true

class Admin::TagsController < Admin::BaseController
  before_action :require_admin!
  before_action :set_tag, only: %i[show edit update destroy]

  def index
    @tags = Tag.popular
  end

  def show; end

  def new
    @tag = Tag.new(color: Tag::COLORS.sample)
  end

  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      redirect_to admin_tag_path(@tag), notice: "Tag created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @tag.update(tag_params)
      redirect_to admin_tag_path(@tag), notice: "Tag updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy
    redirect_to admin_tags_path, notice: "Tag deleted."
  end

  private

  def set_tag
    @tag = Tag.friendly.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :color)
  end
end
