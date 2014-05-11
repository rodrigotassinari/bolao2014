# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :team do
    name_en 'Brazil'
    name_pt 'Brasil'
    acronym 'BRA'
    group 'A'
  end

  factory :other_team, class: Team do
    name_en 'Croatia'
    name_pt 'Croácia'
    acronym 'CRO'
    group 'A'
  end
end
