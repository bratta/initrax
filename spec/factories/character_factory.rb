# frozen_string_literal: true

FactoryGirl.define do
  factory :character do
    name Faker::Zelda.character
    hit_points 10
    initiative_bonus 4
    roll_automatically false
    is_player true
    level 5
    active true
    display_order 0
  end
end
