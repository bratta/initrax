RSpec.describe Combatant, type: :model do
  subject { FactoryGirl.build(:combatant) }
  it { should belong_to :user }
  it { should belong_to :combat }
  it { should belong_to :character }

  describe "#active" do
    it 'includes combatants with the active flag' do
      active = FactoryGirl.create(:combatant, active: true)
      expect(Combatant.active).to include(active)
    end

    it 'excludes combatants without the active flag' do
      inactive = FactoryGirl.create(:combatant, active: false)
      expect(Combatant.active).to_not include(inactive)
    end
  end
end