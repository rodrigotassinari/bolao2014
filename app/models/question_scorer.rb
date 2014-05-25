class QuestionScorer
  # include Scorer # TODO?

  attr_reader :question

  # TODO spec
  def initialize(question)
    @question = question
  end

  # Score all existing question_bets for this question (calculates the points and saves on the question_bets).
  # Can be run any number of times.
  # TODO spec
  def score_all!
    false # TODO
  end

end
