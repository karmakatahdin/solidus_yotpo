class AddReviewsCounterToSpreeProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_products, :reviews_count, :integer, default: 0, null: false
  end
end
