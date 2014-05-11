# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :match_bet do
    goals_a 2
    goals_b 0

    association :bet, factory: :bet, strategy: :build
    association :match, factory: :match, strategy: :build
  end
end
