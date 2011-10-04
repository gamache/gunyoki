class CreateClansPlayers < ActiveRecord::Migration
  def change
    create_table :clans_players do |t|
      t.integer :clan_id,   :null => false
      t.integer :player_id, :null => false
      t.timestamps
    end
    add_index :clans_players, :clan_id
    add_index :clans_players, :player_id
  end
end

