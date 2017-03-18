class AddColsToChapters < ActiveRecord::Migration[5.0]
  def change
    add_column :chapters, :email, :string
    add_column :chapters, :location, :text
    add_column :chapters, :home, :text
    add_column :chapters, :donation, :text
    add_column :chapters, :intake, :text
    add_column :chapters, :latitude, :float
    add_column :chapters, :longitude, :float
  end
end
