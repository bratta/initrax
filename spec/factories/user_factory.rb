FactoryGirl.define do
  factory :user do
    transient do
      number_of_combats 2
      number_of_characters_per_combat 5
    end
    sequence(:email) { |n| "user#{n}@example.com" }
    confirmed_at DateTime.now
    password "beeftaco"
    sequence(:username) {|n| "misterdobalina#{n}" }

    after :create do |user, evaluator|
      (0..evaluator.number_of_combats-1).each do |i|
        user.combats << FactoryGirl.create(:combat, user: user, number_of_combatants: evaluator.number_of_characters_per_combat)
      end
      user.reload
    end
  end
end