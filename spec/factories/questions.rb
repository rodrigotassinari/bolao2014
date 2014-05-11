# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :team_question, class: Question do
    body_en 'Which team will be the champion?'
    body_pt 'Que país será o campeão?'
    played_at '2014-06-12 17:00:00 -0300'.to_time
    answer_type 'team'
    answer nil
  end

  factory :player_question, class: Question do
    body_en 'Which player will score the most goals (Golden Foot trophy)?'
    body_pt 'Que jogador será o artilheiro (troféu Chuteira de Ouro)?'
    played_at '2014-06-12 17:00:00 -0300'.to_time
    answer_type 'player'
    answer nil
  end

  factory :boolean_question, class: Question do
    body_en 'Will there be any field invasion during the tournament?'
    body_pt 'Haverá alguma invasão de campo durante o campeonato?'
    played_at '2014-06-12 17:00:00 -0300'.to_time
    answer_type 'boolean'
    answer nil
  end
end
