class QuestionBetsController < ApplicationController

  before_action :find_bet
  before_action :find_question
  before_action :find_question_bet

  # GET /bet/questions/:question_id
  # Via: question_bet_path(:question_id)
  #
  # Shows the bet of the current user on the supplied question, if any.
  # TODO spec
  def edit
  end

  # POST /bet/questions/:question_id
  # Via: question_bet_path(:question_id)
  #
  # Creates a bet on the supplied question by the current user.
  # TODO spec
  def create
    @_question_bet.attributes = question_bet_params
    if @_question_bet.save
      flash[:success] = t('.success', question_number: @_question.number)
      redirect_to_next_bettable(@_question_bet)
    else
      render :edit
    end
  end

  # PUT /bet/questions/:question_id
  # Via: question_bet_path(:question_id)
  #
  # Updates the bet on the supplied question by the current user.
  # TODO spec
  def update
    @_question_bet.attributes = question_bet_params
    if @_question_bet.save
      flash[:success] = t('.success', question_number: @_question.number)
      redirect_to_next_bettable(@_question_bet)
    else
      render :edit
    end
  end

  private

  def find_bet
    @_bet = current_user.bet
    @bet = BetPresenter.new(@_bet)
  end

  def find_question
    @_question = Question.find(params[:question_id])
    @question = QuestionPresenter.new(@_question)
  end

  def find_question_bet
    @_question_bet = @_bet.question_bets.find_or_initialize_by(question: @_question)
    @question_bet = QuestionBetPresenter.new(@_question_bet)
  end

  def question_bet_params
    params.require(:question_bet).permit(:answer)
  end

  def redirect_to_next_bettable(question_bet)
    if next_question = question_bet.next_question_to_bet
      redirect_to question_bet_path(next_question)
    else
      redirect_to bet_path
    end
  end

end
