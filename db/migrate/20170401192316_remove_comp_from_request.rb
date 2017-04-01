class RemoveCompFromRequest < ActiveRecord::Migration[5.0]
  def change
    remove_column :requests, :completed, :boolean
    remove_column :requests, :completionnote, :text
  end
end
