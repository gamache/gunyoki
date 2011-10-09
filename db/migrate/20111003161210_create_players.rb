class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name, :null => false
      t.string :sha512_password
      t.string :salt

      t.timestamps
    end
  end
end
