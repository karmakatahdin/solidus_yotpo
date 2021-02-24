class AddReviewsCounterToSpreeUsers < ActiveRecord::Migration[6.0]
  def change
    add_column Spree.user_class.table_name, :reviews_count, :integer, default: 0, null: false
  end
end
