class MatchesController < ApplicationController

  # GET /matches
  # Via: matches_path
  def index
    @_matches = Match.includes([:team_a, :team_b]).all_in_order
    @matches = MatchPresenter.map(@_matches)
  end

  # GET /matches/:id
  # Via: match_path(:id)
  def show
    @_match = Match.find(params[:id])
    @match = MatchPresenter.new(@_match)
  end

end
