# frozen_string_literal: true

module Spree
  class ReviewsController < StoreController
    helper Spree::BaseHelper
    helper SolidusYotpo::BaseHelper

    before_action :load_product, only: %i[create new]

    def new
      @review = SolidusYotpo::Review.new(product: @product)
      authorize! :create, @review
    end

    def create
      @review = SolidusYotpo::Review.new(review_params)
      @review.product = @product
      @review.user = spree_current_user

      authorize! :create, @review

      if @review.save
        flash[:notice] = I18n.t('solidus_yotpo.create.success')
        redirect_to spree.product_path(@product)
      else
        render :new
      end
    end

    private

    def load_product
      @product = Spree::Product.friendly.find(params[:product_id])
    end

    def permitted_review_attributes
      %i[title content score]
    end

    def review_params
      params.require(:review).permit(permitted_review_attributes)
    end
  end
end
