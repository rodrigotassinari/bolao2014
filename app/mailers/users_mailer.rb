class UsersMailer < ActionMailer::Base
  layout 'emails'

  def match_bet_scored(match_bet_id, from_points, to_points)
    mail to: 'to@example.org'
  end

  def question_bet_scored(question_bet_id, from_points, to_points)
    mail to: 'to@example.org'
  end

end
