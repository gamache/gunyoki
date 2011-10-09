class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :player_id, :null => false
      t.integer :server_id, :null => false
      t.string :name, :null => false

      t.timestamps
    end
    add_index :accounts, :player_id
    add_index :accounts, :server_id
    add_index :accounts, :name
  end
end
