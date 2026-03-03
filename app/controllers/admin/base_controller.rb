# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_or_author!

  layout "admin"

  private

  def require_admin_or_author!
    unless current_user&.role_admin? || current_user&.role_author?
      redirect_to root_path, alert: "Access denied."
    end
  end

  def require_admin!
    unless current_user&.role_admin?
      redirect_to admin_root_path, alert: "Only admins can perform this action."
    end
  end
end
