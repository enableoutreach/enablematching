class AddTokenToChapters < ActiveRecord::Migration[5.0]
  def change
    add_column :chapters, :token, :text
  end
end
