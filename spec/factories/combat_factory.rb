FactoryGirl.define do
  factory :combat do
    transient do
      number_of_combatants 3
    end

    after :build do |combat, evaluator|
      (0..evaluator.number_of_combatants-1).each do |i|
        combat.combatants << FactoryGirl.create(:combatant, user: combat.user)
      end
    end
    sequence(:name) { |n| "combat #{n}" }
    active true
  end
end