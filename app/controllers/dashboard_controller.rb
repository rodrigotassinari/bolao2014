class DashboardController < ApplicationController

  skip_before_action :require_login, only: [:index]

  # GET /
  # Via: root_path
  def index
  end

end
