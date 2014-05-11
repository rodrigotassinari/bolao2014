# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :team_question_bet, class: QuestionBet do

    answer '42'

    association :bet, factory: :bet, strategy: :build
    association :question, factory: :team_question, strategy: :build
  end

  factory :player_question_bet, class: QuestionBet do
    answer '42'

    association :bet, factory: :bet, strategy: :build
    association :question, factory: :player_question, strategy: :build
  end

  factory :boolean_question_bet, class: QuestionBet do
    answer 'true'

    association :bet, factory: :bet, strategy: :build
    association :question, factory: :boolean_question, strategy: :build
  end
end
