require 'sidekiq/web'
Rails.application.routes.draw do

  get '/help' => 'pages#help', as: 'help'

  root 'dashboard#index'

  get '/login' => 'sessions#new', as: 'login'
  post '/one_time_token' => 'sessions#one_time_token', as: 'one_time_token'
  post '/login' => 'sessions#create'

  get '/logout' => 'sessions#destroy', as: 'logout'

  resources :matches, only: [:index, :show]
  resources :questions, only: [:index, :show]
  resources :bets, only: [:index, :show]

  get '/my_bet' => 'my_bet#show', as: 'my_bet'
  get '/my_bet/matches' => 'my_bet#matches', as: 'my_bet_matches'
  get '/my_bet/questions' => 'my_bet#questions', as: 'my_bet_questions'

  get '/my_bet/payment' => 'payments#new', as: 'my_bet_payment'
  post '/my_bet/payment' => 'payments#create'
  post '/payment_notifications' => 'payments#update', as: 'payment_notifications'

  get  '/my_bet/matches/:match_id' => 'match_bets#edit', as: 'my_match_bet'
  post '/my_bet/matches/:match_id' => 'match_bets#create'
  put  '/my_bet/matches/:match_id' => 'match_bets#update'

  get  '/my_bet/questions/:question_id' => 'question_bets#edit', as: 'my_question_bet'
  post '/my_bet/questions/:question_id' => 'question_bets#create'
  put  '/my_bet/questions/:question_id' => 'question_bets#update'

  namespace :admin do
    resources :matches, only: [:index, :show, :edit, :update]
  end

  # TODO limit access to admins, see https://github.com/mperham/sidekiq/wiki/Monitoring#security
  mount Sidekiq::Web => '/admin/sidekiq'

end
