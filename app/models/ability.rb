# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user, namespace
    can :read, Subject
    return if user.blank?

    case namespace
    when "Admin"
      admin_can if user.admin?
    when ""
      user_can user
    end
  end

  private

  def user_can user
    can [:create, :update, :index, :show], Exam, user_id: user.id
  end

  def admin_can
    can :manage, :all
  end
end
