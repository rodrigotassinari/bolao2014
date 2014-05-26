class QuestionBetPoints

  attr_reader :question_bet

  def initialize(question_bet)
    @question_bet = question_bet
  end

  def points
    @points = 0
    @points += result_points
    @points
  end

  # Returns true if the question_bet answer is correct (matches the question answer).
  # TODO spec
  def correct_answer?
    question_bet.question.scorable? && question_bet.answer == question_bet.question.answer
  end

  # TODO spec
  def result_points
    correct_answer? ? question_bet.question.result_points : 0
  end

end