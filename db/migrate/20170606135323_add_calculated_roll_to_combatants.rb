class AddCalculatedRollToCombatants < ActiveRecord::Migration[5.0]
  def change
    add_column :combatants, :calculated_roll, :integer
  end
end
