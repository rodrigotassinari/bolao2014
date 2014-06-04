class QuestionsController < ApplicationController

  # GET /questions
  # Via: questions_path
  def index
    @_questions = Question.all_in_order
    @questions = QuestionPresenter.map(@_questions)
  end

  # GET /questions/:id
  # Via: question_path(:id)
  def show
    @_question = Question.find(params[:id])
    @question = QuestionPresenter.new(@_question)
  end

end
