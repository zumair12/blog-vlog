# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # Security
  protect_from_forgery with: :exception

  # Rescue unauthorized access
  rescue_from Pundit::NotAuthorizedError, with: :handle_unauthorized
  rescue_from ActiveRecord::RecordNotFound,  with: :handle_not_found

  # Before actions
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Set default meta tags
  before_action :set_default_meta_tags

  private

  def handle_unauthorized
    respond_to do |format|
      format.html do
        flash[:alert] = "You are not authorized to perform this action."
        redirect_back fallback_location: root_path
      end
      format.json { render json: { error: "Unauthorized" }, status: :unauthorized }
    end
  end

  def handle_not_found
    respond_to do |format|
      format.html { render "errors/not_found", status: :not_found }
      format.json { render json: { error: "Not found" }, status: :not_found }
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username bio website twitter_handle avatar])
  end

  def set_default_meta_tags
    set_meta_tags(
      site: "BlogVlog",
      title: "BlogVlog – Ideas Worth Sharing",
      description: "A modern blog platform with rich content, categories, and community discussions.",
      keywords: "blog, articles, tutorials, ideas",
      og: {
        site_name: "BlogVlog",
        type: "website"
      },
      twitter: {
        card: "summary_large_image",
        site: "@blogvlog"
      }
    )
  end
end
