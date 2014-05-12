class BetsController < ApplicationController

  # GET /bet
  # Via: bet_path
  #
  # Shows a summary of the current user's bet
  def show
    @bet = current_user.bet
    @_matches = Match.all_bettables_in_order
    @matches = MatchPresenter.map(@_matches)
    @questions = Question.all_bettables_in_order
  end

end
