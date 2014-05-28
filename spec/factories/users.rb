# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email 'someone@example.com'
    time_zone 'Brasilia' # default time zone
    locale 'pt' # default locale
  end

  factory :admin_user, class: User do
    email 'admin@example.com'
    time_zone 'Brasilia' # default time zone
    locale 'pt' # default locale
    admin true # default is false
  end

  factory :user_en, class: User do
    name 'John Doe'
    email 'john.doe@example.com'
    time_zone 'Eastern Time (US & Canada)'
    locale 'en'
  end

  factory :user_pt, class: User do
    name 'João da Silva'
    email 'joao.silva@example.com.br'
    time_zone 'Brasilia'
    locale 'pt'
  end
end
