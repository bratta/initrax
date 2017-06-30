# frozen_string_literal: true

RSpec.describe CombatantSerializer do
  subject { CombatantSerializer.new(FactoryGirl.create(:combatant)) }

  it 'includes the expected attributes' do
    expect(subject_json(subject).keys).to contain_exactly(
      'id', 'hit_points', 'notes', 'display_order',
      'user_id', 'calculated_roll', 'character', 'combat'
    )
  end

  it 'includes the keys for the character' do
    expect(subject_json(subject)['character'].keys).to contain_exactly(
      'id', 'name', 'hit_points', 'initiative_bonus',
      'roll_automatically', 'is_player', 'level',
      'display_order', 'user_id'
    )
  end
end
