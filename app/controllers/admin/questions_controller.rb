class Admin::QuestionsController < ApplicationController

  before_action :find_question, except: [:index]

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
      redirect_to question_path(@question)
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
