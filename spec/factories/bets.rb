# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bet do
    association :user, factory: :user, strategy: :build
    points 0
  end
end
