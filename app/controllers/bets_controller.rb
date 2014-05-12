class BetsController < ApplicationController

  def show
    @bet = current_user.bet
    @matches = Match.all_bettables_in_order
  end

end
