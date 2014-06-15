class BetsController < ApplicationController

  # GET /bets
  # Via: bets_path
  def index
    @_bets = Bet.includes(:payment).order("points desc").all
    @bets = BetPresenter.map(@_bets)
    @paid_bets_count = @bets.select(&:paid?).size
    @paying_bets_count = @bets.select(&:paying?).size
  end

  # GET /bets/:id
  # Via: bet_path(:id)
  #
  # Shows a summary of the requested bet
  # TODO spec
  def show
    @_bet = Bet.find(params[:id])
    @bet = BetPresenter.new(@_bet)
  end

end
