class CreateCombats < ActiveRecord::Migration[5.0]
  def change
    create_table :combats do |t|
      t.integer :user_id
      t.string :name
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
