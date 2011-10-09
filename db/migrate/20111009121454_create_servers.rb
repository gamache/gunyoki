class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :name, :null => false
      t.text :description

      t.integer :owner_id

      t.string :protocol, :default => 'ssh'
      t.string :hostname
      t.integer :port

      t.timestamps
    end
  end
end
