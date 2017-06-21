RSpec.describe Character, type: :model do
  subject { FactoryGirl.build(:character) }

  it { should validate_presence_of :name }

  it { should belong_to :user }
  it { should have_many :combatants }
  it { should have_many(:combats).through :combatants }
  it { should accept_nested_attributes_for :combatants }

  describe "#active" do
    it 'includes characters with the active flag' do
      active = FactoryGirl.create(:character, active: true)
      expect(Character.active).to include(active)
    end

    it 'excludes characters without the active flag' do
      inactive = FactoryGirl.create(:character, active: false)
      expect(Character.active).to_not include(inactive)
    end
  end
end