class CreateNotices < ActiveRecord::Migration[5.0]
  def change
    create_table :notices do |t|
      t.text :content
      t.boolean :sticky
      t.date :expires

      t.timestamps
    end
  end
end
