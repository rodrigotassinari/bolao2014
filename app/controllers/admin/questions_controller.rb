class Admin::QuestionsController < ApplicationController

  before_action :find_question, except: [:index]

  # GET /admin/questions
  # Via: admin_questions_path
  #
  # Lists all questions available to the admin
  # TODO spec
  def index
    @_questions = Question.all_in_order
    @questions = QuestionPresenter.map(@_questions)
  end

  # GET /admin/questions/:id
  # Via: admin_question_path(:id)
  #
  # Shows the information of one question to the admin
  # TODO spec
  def show
  end

  # GET /admin/questions/:id/edit
  # Via: edit_admin_question_path(:id)
  #
  # Shows the form for the admin to change information of a question
  # TODO spec
  def edit
  end

  # PUT /admin/questions/:id
  # Via: admin_question_path(:id)
  #
  # Changes the information of a question by the admin
  # TODO spec
  def update
    updater = QuestionUpdater.new(@_question, question_params) # TODO QuestionUpdater
    if updater.save
      flash[:success] = updater.message
      redirect_to admin_question_path(@question)
    else
      flash.now[:error] = t('.update_error')
      render :edit
    end
  end

  private

  def find_question
    @_question = Question.find(params[:id])
    @question = QuestionPresenter.new(@_question)
  end

  def question_params
    params.require(:question).permit(:answer)
  end

end
