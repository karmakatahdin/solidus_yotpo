class CreateSolidusYotpoReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :solidus_yotpo_reviews do |t|
      t.string :title
      t.text :content
      t.integer :score
      t.integer :votes_up
      t.integer :votes_down

      t.references :product
      t.references :user

      t.timestamps
    end
  end
end
