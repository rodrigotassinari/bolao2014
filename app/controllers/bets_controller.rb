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

end
