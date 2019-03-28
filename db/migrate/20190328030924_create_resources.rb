class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources do |t|
      t.string :name
      t.string :filename

      t.timestamps
    end
    add_index :resources, :name
    add_index :resources, :filename
  end
end
