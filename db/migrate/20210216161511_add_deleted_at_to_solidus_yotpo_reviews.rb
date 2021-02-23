class AddDeletedAtToSolidusYotpoReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :solidus_yotpo_reviews, :deleted_at, :datetime
  end
end
