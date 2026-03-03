# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  # Authors can create posts
  def create? = user.present? && (user.role_author? || user.role_admin?)

  # Admins can see all; authors can see their own
  def show?    = admin? || owner?
  def edit?    = admin? || owner?
  def update?  = admin? || owner?
  def destroy? = admin? || owner?

  # Published post actions
  def publish?   = admin? || owner?
  def archive?   = admin? || owner?
  def feature?   = admin?
  def unfeature? = admin?

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.role_admin?
        scope.all
      elsif user&.role_author?
        scope.where(user: user)
      else
        scope.status_published
      end
    end
  end

  private

  def admin? = user&.role_admin?
  def owner? = record.user == user
end
