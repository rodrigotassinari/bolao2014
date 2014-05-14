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
    @_match_bet.attributes = match_bet_params
    if @_match_bet.save
      flash[:success] = t('.success', match_number: @_match.number)
      redirect_to_next_bettable(@_match_bet)
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
    @_match_bet.attributes = match_bet_params
    if @_match_bet.save
      flash[:success] = t('.success', match_number: @_match.number)
      redirect_to_next_bettable(@_match_bet)
    else
      render :edit
    end
  end

  private

  def find_bet
    @_bet = current_user.bet
    # @bet = BetPresenter.new(@_bet) # TODO
  end

  def find_match
    @_match = Match.with_known_teams.find(params[:match_id])
    @match = MatchPresenter.new(@_match)
  end

  def find_match_bet
    @_match_bet = @_bet.match_bets.find_or_initialize_by(match: @_match)
    @match_bet = MatchBetPresenter.new(@_match_bet)
  end

  def match_bet_params
    params.require(:match_bet).permit(:goals_a, :goals_b, :penalty_winner_id)
  end

  def redirect_to_next_bettable(match_bet)
    if next_match = match_bet.next_match_to_bet
      redirect_to match_bet_path(next_match)
    else
      redirect_to bet_path
    end
  end

end
