class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :player_id, :null => false
      t.integer :tournament_id

      t.string                :player_name
      t.string                :role
      t.string                :race
      t.string                :gender
      t.string                :alignment
      t.string                :end_gender
      t.string                :end_alignment

      t.integer               :end_level
      t.integer               :end_hp
      t.integer               :max_level
      t.integer               :max_hp
      t.string                :end_msg
      t.string                :end_loc
      t.integer               :deaths

      t.integer               :turns
      t.datetime              :start_time
      t.datetime              :end_time
      t.integer               :seconds_played
      t.integer               :score

      ## the achievement bitfield, lsb to msb
      t.boolean               :got_bell
      t.boolean               :entered_gehennom
      t.boolean               :got_candelabrum
      t.boolean               :got_book
      t.boolean               :did_invocation
      t.boolean               :got_amulet
      t.boolean               :reached_elemental
      t.boolean               :reached_astral
      t.boolean               :ascended
      t.boolean               :did_mines
      t.boolean               :did_sokoban
      t.boolean               :killed_medusa
      t.integer               :achievements, :default => 0

      ## the conduct bitfield, lsb to msb
      t.boolean               :foodless
      t.boolean               :vegan
      t.boolean               :vegetarian
      t.boolean               :atheist
      t.boolean               :weaponless
      t.boolean               :pacifist
      t.boolean               :illiterate
      t.boolean               :polypileless
      t.boolean               :polyselfless
      t.boolean               :wishless
      t.boolean               :artifact_wishless
      t.boolean               :genocideless
      t.integer               :conducts, :default => 0

      t.timestamps
    end
    add_index :games, :player_id
    add_index :games, :tournament_id
    add_index :games, :ascended
  end
end

