class AddReviewsSummaryFieldsToSpreeProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_products, :average_score, :decimal, precision: 2, scale: 1, default: 0, null: true
    add_column :spree_products, :star_distribution, :integer, array: true, default: [], null: true
  end
end
