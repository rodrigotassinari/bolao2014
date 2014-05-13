# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :match do
    number 1
    round 'group'
    group 'A'
    played_at '2014-06-12 17:00:00 -0300'.to_time
    played_on 'sp'

    association :team_a, factory: :team, strategy: :build
    association :team_b, factory: :other_team, strategy: :build
  end

  factory :future_match, class: Match do
    number 64
    round 'final'
    group nil
    played_at '2014-07-13 16:00:00 -0300'.to_time
    played_on 'rj'
    team_a nil
    team_b nil
  end
end
