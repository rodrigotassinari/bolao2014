class QuestionUpdater

  # include EventScorer # TODO?

  attr_reader :question
  attr_accessor :changes

  def initialize(question, changes={})
    @question = question
    @changes = changes
    @question_bettable_before_changes = question.bettable?
    @messages = []
  end

  def valid?
    raise ArgumentError, 'question is not persisted' unless question.persisted?
    raise ArgumentError, 'nothing to change on the question' if changes.empty?
    true
  end

  # Tries to change the question attributes and, if successful, queues the
  # question scoring (only if needed?), the new question available to bet notificattion
  # and returns true. If not, returns false with the errors set on the question object.
  def save
    question.attributes = changes
    if successful_question_change
      notify_users_if_question_is_now_bettable
      score_question_if_question_is_now_scorable
      true
    else
      false
    end
  end

  # Message to explain what was done after successful `save`
  def message
    return if @messages.empty?
    @messages.join(' ')
  end

  def errors
    question.errors
  end

  private

  def successful_question_change
    if valid? && question.changed? && question.save
      @messages << I18n.t('question_updater.question_changed')
      true
    else
      false
    end
  end

  def notify_users_if_question_is_now_bettable
  end

  def score_question_if_question_is_now_scorable
    if question.scorable?
      # async score all question_bets for this question
      QuestionScoreWorker.perform_async(question.id)
      @messages << I18n.t('question_updater.question_scored')
    end
  end

end
