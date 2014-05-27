class UsersMailer < ActionMailer::Base
  layout 'emails'

  def self.async_deliver(method, *args)
    EmailWorker.perform_async(
      'UsersMailer',
      method.to_s,
      args
    )
  end

  def self.send_bet_reminders(hours_before)
    send_match_bet_reminders(hours_before)
    send_question_bet_reminders(hours_before)
  end

  def self.send_match_bet_reminders(hours_before)
    Bet.find_each do |bet|
      bet.bettable_matches_still_to_bet.hours_from_being_locked(hours_before).find_each do |match|
        async_deliver(:match_bet_reminder, match.id, bet.id)
      end
    end
  end

  def self.send_question_bet_reminders(hours_before)
    Bet.find_each do |bet|
      bet.bettable_questions_still_to_bet.hours_from_being_locked(hours_before).find_each do |question|
        async_deliver(:question_bet_reminder, question.id, bet.id)
      end
    end
  end

  def match_bet_scored(match_bet_id, from_points, to_points)
    _match_bet = MatchBet.find(match_bet_id)
    @match_bet = MatchBetPresenter.new(_match_bet)
    @from_points = from_points
    @to_points = to_points
    @match = @match_bet.match
    @bet = @match_bet.bet
    @user = @bet.user
    mail(
      subject: t('users_mailer.match_bet_scored.subject', subject_prefix: subject_prefix, match_number: @match.number),
      to: @user.email_with_name
    )
  end

  def question_bet_scored(question_bet_id, from_points, to_points)
    _question_bet = QuestionBet.find(question_bet_id)
    @question_bet = QuestionBetPresenter.new(_question_bet)
    @from_points = from_points
    @to_points = to_points
    @question = @question_bet.question
    @bet = @question_bet.bet
    @user = @bet.user
    mail(
      subject: t('users_mailer.question_bet_scored.subject', subject_prefix: subject_prefix, question_number: @question.number),
      to: @user.email_with_name
    )
  end

  def match_bet_reminder(match_id, bet_id)
    _match = Match.find(match_id)
    _bet = Bet.find(bet_id)
    @match = MatchPresenter.new(_match)
    @user = UserPresenter.new(_bet.user)
    mail(
      subject: t('users_mailer.match_bet_reminder.subject', subject_prefix: subject_prefix, match_number: @match.number),
      to: @user.email_with_name
    )
  end

  def question_bet_reminder(question_id, bet_id)
    _question = Question.find(question_id)
    _bet = Bet.find(bet_id)
    @question = QuestionPresenter.new(_question)
    @user = UserPresenter.new(_bet.user)
    mail(
      subject: t('users_mailer.question_bet_reminder.subject', subject_prefix: subject_prefix, question_number: @question.number),
      to: @user.email_with_name
    )
  end

  private

  def subject_prefix
    ENV['APP_SHORT_NAME'].dup.force_encoding('UTF-8')
  end

end
