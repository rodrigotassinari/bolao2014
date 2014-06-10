class UsersController < ApplicationController

  before_action :find_user

  # GET /profile
  # Via: profile_path
  #
  # Shows the logged in user the form where he can change his personal information.
  def edit
  end

  # PUT /profile
  # Via: profile_path
  #
  # Updates the personal information of the logged in user.
  # TODO spec
  def update
    # TODO
  end

  private

  def find_user
    @user = UserPresenter.new(current_user)
  end

end
