# frozen_string_literal: true

class SolidusYotpo::ReviewsAbility
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can :create, SolidusYotpo::Review
      can :review, Spree::Product do |product|
        user.orders.joins(:products).complete.exists?(spree_products: { id: product.id })
      end
    end
  end
end
