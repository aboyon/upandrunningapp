class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources do |t|
      t.string :name
      t.string :filename
      t.string :tags
      t.timestamps
    end
    add_index :resources, :name
    add_index :resources, :filename
    add_index :resources, :tags
  end
end
