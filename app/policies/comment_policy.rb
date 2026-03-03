# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  def create?  = user.present?
  def destroy? = admin? || owner?
  def update?  = admin?
  def approve? = admin?
  def reject?  = admin?

  private

  def admin? = user&.role_admin?
  def owner? = record.user == user
end
