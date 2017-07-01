# frozen_string_literal: true

RSpec.describe Combat, type: :model do
  subject { FactoryGirl.build(:combat) }

  it { should validate_presence_of :name }

  it { should belong_to :user }
  it { should have_many :combatants }
  it { should have_many(:characters).through :combatants }
  it { should accept_nested_attributes_for :combatants }

  describe '#active' do
    it 'includes combats with the active flag' do
      active = FactoryGirl.create(:combat, active: true)
      expect(Combat.active).to include(active)
    end

    it 'excludes combats without the active flag' do
      inactive = FactoryGirl.create(:combat, active: false)
      expect(Combat.active).to_not include(inactive)
    end
  end
end
