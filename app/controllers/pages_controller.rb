class PagesController < ApplicationController

  skip_before_action :require_login, only: [:help]

  # GET /help
  # Via: help_path
  #
  # Help, rules, FAQ, etc
  def help
    @_first_match = Match.ordered.first
    @first_match = MatchPresenter.new(@_first_match)
    @_bet = Bet.new
    @bet = BetPresenter.new(@_bet)
  end

end
