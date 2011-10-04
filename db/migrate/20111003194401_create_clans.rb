class CreateClans < ActiveRecord::Migration
  def change
    create_table :clans do |t|

      t.timestamps
    end
  end
end
