# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :field_player, class: Player do
    name 'Fulano de Tal'

    association :team, factory: :team, strategy: :build
  end

  factory :goal_player, class: Player do
    name 'Beltrano da Silva'
    position 'goalkeeper'

    association :team, factory: :team, strategy: :build
  end
end
