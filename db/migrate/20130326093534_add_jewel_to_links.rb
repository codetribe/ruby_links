class AddJewelToLinks < ActiveRecord::Migration
  def change
    add_column :links, :jewel, :integer, default: 0
  end
end
