FactoryGirl.define do
  factory :combatant do
    hit_points 10
    notes "Some notes here"
    active true
    display_order 0
    calculated_roll 12

    after :create do |combatant, evaluator|
      combatant.character = FactoryGirl.create(:character, user: combatant.user)
    end
  end
end