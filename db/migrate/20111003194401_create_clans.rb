class CreateClans < ActiveRecord::Migration
  def change
    create_table :clans do |t|
      t.string :name, :null => false
      t.text :description
      t.integer :owner_id

      t.timestamps
    end
  end
end
