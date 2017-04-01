class AddEvidenceToRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :requests, :evidence, :text
  end
end
