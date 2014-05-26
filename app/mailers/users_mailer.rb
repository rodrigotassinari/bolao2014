class UsersMailer < ActionMailer::Base
  layout 'emails'

  def self.async_deliver(method, *args)
    EmailWorker.perform_async(
      'UsersMailer',
      method.to_s,
      args
    )
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
      subject: t('.subject', subject_prefix: subject_prefix, match_number: @match.number),
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
      subject: t('.subject', subject_prefix: subject_prefix, question_number: @question.number),
      to: @user.email_with_name
    )
  end

  private

  def subject_prefix
    ENV['APP_SHORT_NAME'].dup.force_encoding('UTF-8')
  end

end
