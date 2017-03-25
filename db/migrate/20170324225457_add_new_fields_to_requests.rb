class AddNewFieldsToRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :requests, :photos, :text
    add_column :requests, :measurements, :text
    add_column :requests, :colors, :text
  end
end
