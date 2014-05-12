class MatchesController < ApplicationController

  # GET /matches
  # Via: matches_path
  def index
    @matches = MatchPresenter.map(Match.all_in_order)
  end

  # GET /matches/:id
  # Via: match_path(:id)
  def show
    @match = MatchPresenter.new(Match.find(params[:id]))
  end

end
