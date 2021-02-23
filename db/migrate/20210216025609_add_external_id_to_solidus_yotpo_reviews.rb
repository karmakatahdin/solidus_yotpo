class AddExternalIdToSolidusYotpoReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :solidus_yotpo_reviews, :external_id, :string
  end
end
