class AddCompletedToRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :requests, :completed, :boolean
  end
end
