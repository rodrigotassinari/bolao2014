class BetsController < ApplicationController

  # GET /bet
  # Via: bet_path
  #
  # Shows a summary of the current user's bet
  def show
    @bet = current_user.bet
    @matches = Match.all_bettables_in_order
    @questions = Question.all_bettables_in_order
  end

end
