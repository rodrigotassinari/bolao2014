class MatchesController < ApplicationController

  # GET /matches
  # Via: matches_path
  def index
    @matches = Match.all_in_order
  end

  # GET /matches/:id
  # Via: match_path(:id)
  def show
    @match = Match.find(params[:id])
  end

end
