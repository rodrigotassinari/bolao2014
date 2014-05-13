class BetsController < ApplicationController

  # GET /bet
  # Via: bet_path
  #
  # Shows a summary of the current user's bet
  def show
    @_bet = current_user.bet
    @_matches = @_bet.bettable_matches_still_to_bet.all
    @_questions = @_bet.bettable_questions_still_to_bet.all

    @bet = BetPresenter.new(@_bet)
    @matches = MatchPresenter.map(@_matches)
    @questions = QuestionPresenter.map(@_questions)
  end

  # GET /bet/matches?filter=[betted|to_bet]
  # Via: bet_matches_path(filter: [:betted|:to_bet])
  #
  # List all the matches of the current bet.
  def matches
    # TODO
  end

  # GET /bet/questions?filter=[betted|to_bet]
  # Via: bet_questions_path(filter: [:betted|:to_bet])
  #
  # List all the questions of the current bet.
  def questions
    # TODO
  end

end
