# frozen_string_literal: true

class SolidusYotpo::ReviewsAbility
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can :create, SolidusYotpo::Review
    end
  end
end
