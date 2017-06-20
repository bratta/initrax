FactoryGirl.define do
  factory :character do
    sequence(:name) { |n| "character#{n}" }
    hit_points 10
    initiative_bonus 4
    roll_automatically false
    is_player true
    level 5
    active true
    display_order 0
  end
end