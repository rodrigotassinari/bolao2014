class MatchBetsController < ApplicationController

  before_action :find_bet
  before_action :find_match
  before_action :find_match_bet

  # GET /bet/matches/:match_id
  # Via: match_bet_path(:match_id)
  #
  # Shows the bet of the current user on the supplied match, if any.
  # TODO spec
  def edit
  end

  # POST /bet/matches/:match_id
  # Via: match_bet_path(:match_id)
  #
  # Creates a bet on the supplied match by the current user.
  # TODO spec
  def create
    @bet_match.attributes = bet_match_params
    if @bet_match.save
      flash[:success] = 'OK' # TODO i18n
      redirect_to bet_path
    else
      render :edit
    end
  end

  # PUT /bet/matches/:match_id
  # Via: match_bet_path(:match_id)
  #
  # Updates the bet on the supplied match by the current user.
  # TODO spec
  def update
    # TODO
  end

  private

  def find_bet
    @bet = current_user.bet
  end

  def find_match
    @match = Match.find(params[:match_id])
  end

  def find_match_bet
    @match_bet = @bet.match_bets.find_or_initialize_by(match: @match)
  end

  def bet_match_params
    params.require(:bet_match).permit(:goals_a, :goals_b, :penalty_winner_id)
  end

end
