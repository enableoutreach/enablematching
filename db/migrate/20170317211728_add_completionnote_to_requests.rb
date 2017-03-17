class AddCompletionnoteToRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :requests, :completionnote, :text
  end
end
