# frozen_string_literal: true

FactoryGirl.define do
  factory :combat do
    transient do
      number_of_combatants 3
    end

    after :build do |combat, evaluator|
      (0..evaluator.number_of_combatants - 1).each do |i|
        combat.combatants << FactoryGirl.create(:combatant, user: combat.user, display_order: i)
      end
    end
    name Faker::Pokemon.location
    active true
  end
end
