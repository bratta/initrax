# frozen_string_literal: true

RSpec.describe CharacterSerializer do
  subject { CharacterSerializer.new(FactoryGirl.create(:character, combats: [FactoryGirl.build(:combat)])) }

  it 'includes the expected attributes' do
    expect(subject_json(subject).keys).to contain_exactly(
      'id', 'name', 'hit_points', 'initiative_bonus',
      'roll_automatically', 'is_player', 'level',
      'display_order', 'user_id', 'combats'
    )
  end

  it 'includes the expected combat attributes' do
    expect(subject_json(subject)['combats'][0].keys).to contain_exactly(
      'id', 'name', 'user_id', 'combatants'
    )
  end

  it 'includes the expected combatant attributes in the combat' do
    expect(subject_json(subject)['combats'][0]['combatants'][0].keys).to contain_exactly(
      'id', 'user_id', 'combat_id', 'character_id',
      'hit_points', 'notes', 'display_order', 'active',
      'created_at', 'updated_at', 'calculated_roll'
    )
  end
end
