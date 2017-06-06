class CreateCharacters < ActiveRecord::Migration[5.0]
  def change
    create_table :characters do |t|
      t.integer :user_id
      t.string :name
      t.integer :hit_points, default: 0
      t.integer :initiative_bonus, default: 0
      t.boolean :roll_automatically, default: false
      t.boolean :is_player, default: true
      t.integer :level, default: 1
      t.boolean :active, default: true
      t.integer :display_order, default: 0

      t.timestamps
    end
  end
end
