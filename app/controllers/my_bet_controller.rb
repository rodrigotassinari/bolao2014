class MyBetController < ApplicationController

  before_action :find_bet

  # GET /my_bet
  # Via: my_bet_path
  #
  # Shows a summary of the current user's bet
  def show
    @_matches = @_bet.bettable_matches_still_to_bet.all
    @_questions = @_bet.bettable_questions_still_to_bet.all

    @matches = MatchPresenter.map(@_matches)
    @questions = QuestionPresenter.map(@_questions)
  end

  # GET /my_bet/matches?filter=[betted|to_bet]
  # Via: my_bet_matches_path(filter: [:betted|:to_bet])
  #
  # List all the matches of the current bet.
  def matches
    @_matches = @_bet.filtered_matches(filtered_params[:filter]).all
    @matches = MatchPresenter.map(@_matches)

    @_match_bets = @_bet.filtered_match_bets(filtered_params[:filter]).all
    @match_bets = MatchBetPresenter.map(@_match_bets)
  end

  # GET /my_bet/questions?filter=[betted|to_bet]
  # Via: my_bet_questions_path(filter: [:betted|:to_bet])
  #
  # List all the questions of the current bet.
  def questions
    @_questions = @_bet.filtered_questions(filtered_params[:filter]).all
    @questions = QuestionPresenter.map(@_questions)

    @_question_bets = @_bet.filtered_question_bets(filtered_params[:filter]).all
    @question_bets = QuestionBetPresenter.map(@_question_bets)
  end

  private

  def find_bet
    @_bet = current_user.bet
    @bet = BetPresenter.new(@_bet)
  end

  def filtered_params
    params.permit(:filter)
  end

end
