class CreateLinksTagsTable < ActiveRecord::Migration
  def change
    create_table(:links_tags, id: false) do |t|
      t.integer :link_id
      t.integer :tag_id
    end
    add_index :links_tags, :link_id
    add_index :links_tags, :tag_id
  end
end
