class QuestionScorer
  # include Scorer # TODO?

  attr_reader :question

  def initialize(question)
    @question = question
  end

  # Score all existing question_bets for this question (calculates the points and saves on the question_bets).
  # Can be run any number of times.
  def score_all!
    question.question_bets.find_each do |question_bet|
      question_bet.score!
    end
  end

end
