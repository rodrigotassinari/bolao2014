class Admin::MatchesController < AdminController

  before_action :find_match, except: [:index]

  # GET /admin/matches
  # Via: admin_matches_path
  #
  # Lists all matches available to the admin
  def index
    @_matches = Match.includes([:team_a, :team_b]).all_in_order
    @matches = MatchPresenter.map(@_matches)
  end

  # GET /admin/matches/:id
  # Via: admin_match_path(:id)
  #
  # Shows the information of one match to the admin
  def show
  end

  # GET /admin/matches/:id/edit
  # Via: edit_admin_match_path(:id)
  #
  # Shows the form for the admin to change information of a match
  def edit
  end

  # PUT /admin/matches/:id
  # Via: admin_match_path(:id)
  #
  # Changes the information of a match by the admin
  def update
    updater = MatchUpdater.new(@_match, match_params)
    if updater.save
      flash[:success] = updater.message
      redirect_to admin_match_path(@match)
    else
      flash.now[:error] = t('.update_error')
      render :edit
    end
  end

  private

  def find_match
    @_match = Match.includes([:team_a, :team_b]).find(params[:id])
    @match = MatchPresenter.new(@_match)
  end

  def match_params
    params.require(:match).permit(
      :team_a_id, :team_b_id, :goals_a, :goals_b, :penalty_goals_a, :penalty_goals_b
    )
  end

end
