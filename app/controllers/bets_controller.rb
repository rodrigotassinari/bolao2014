class BetsController < ApplicationController

  # GET /bets
  # Via: bets_path
  def index
    @_bets = Bet.order("points desc").all
    @bets = BetPresenter.map(@_bets)
  end

  # GET /bets/:id
  # Via: bet_path(:id)
  #
  # Shows a summary of the requested bet
  # TODO spec
  def show
    # TODO
    @_bet = Bet.find(params[:id])
    @bet = BetPresenter.new(@_bet)
  end

end
