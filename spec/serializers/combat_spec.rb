RSpec.describe CombatSerializer do
  subject { CombatSerializer.new(FactoryGirl.create(:combat)) }

  it 'includes the expected attributes' do
    expect(subject_json(subject).keys).to contain_exactly('id', 'name', 'user_id', 'combatants')
  end

  it 'orders combatants by display order ascending' do
    expect(subject_json(subject)["combatants"].map {|c| c["display_order"]}).to eq([0, 1, 2])
  end
end