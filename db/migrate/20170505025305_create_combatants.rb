class CreateCombatants < ActiveRecord::Migration[5.0]
  def change
    create_table :combatants do |t|
      t.integer :user_id
      t.integer :combat_id
      t.integer :character_id
      t.integer :hit_points
      t.string :notes
      t.integer :display_order, default: 0
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
