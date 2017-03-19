class AddEvidenceToChapters < ActiveRecord::Migration[5.0]
  def change
    add_column :chapters, :evidence, :text
  end
end
