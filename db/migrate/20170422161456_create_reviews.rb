class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.integer :by
      t.integer :for
      t.string :type
      t.integer :rating
      t.text :title
      t.text :content

      t.timestamps
      
      t.index ["by", "for"], name: "dupeReview", unique: true, using: :btree
    end
  end
end
