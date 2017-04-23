class FixTypeColName < ActiveRecord::Migration[5.0]
  def change
    rename_column :reviews, :type, :target_type
  end
end
