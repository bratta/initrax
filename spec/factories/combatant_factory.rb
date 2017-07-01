# frozen_string_literal: true

FactoryGirl.define do
  factory :combatant do
    hit_points 10
    notes Faker::RickAndMorty.quote
    active true
    display_order 0
    calculated_roll 12

    after :create do |combatant|
      combatant.character = FactoryGirl.create(:character, user: combatant.user)
    end
  end
end
