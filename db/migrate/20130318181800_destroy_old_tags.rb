class DestroyOldTags < ActiveRecord::Migration
  def up
    drop_table :tags
    drop_table :links_tags
  end

  def down
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end
    create_table(:links_tags, id: false) do |t|
      t.integer :link_id
      t.integer :tag_id
    end
    add_index :links_tags, :link_id
    add_index :links_tags, :tag_id
  end
end
