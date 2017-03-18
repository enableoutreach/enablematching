class CreateChapters < ActiveRecord::Migration[5.0]
  def change
    create_table :chapters do |t|
      t.integer :lead
      t.boolean :active
      t.text :name

      t.timestamps
    end
  end
end
