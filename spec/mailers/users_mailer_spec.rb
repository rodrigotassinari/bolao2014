require 'spec_helper'

describe UsersMailer do
  let(:user) { create(:user) }
  let(:bet) { create(:bet, user: user) }

  describe 'match_bet_scored' do
    let(:team_a) { create(:team) }
    let(:team_b) { create(:other_team) }
    let(:match) { create(:match, id: 1, number: 1, team_a: team_a, team_b: team_b, goals_a: 3, goals_b: 2) }
    let!(:match_bet) { create(:match_bet, match: match, bet: bet) }
    let(:mail) { UsersMailer.match_bet_scored(match_bet.id, 0, 42) }
    it 'renders the headers' do
      expect(mail.subject).to eql("[#{ENV['APP_SHORT_NAME']}] Veja quantos pontos você fez na partida ##{match.number}")
      expect(mail.to).to eql([user.email])
      expect(mail.from).to eq([ENV['EMAIL_FROM']])
    end
    it 'renders the body', locale: :pt do
      expect(mail.body.to_s.chomp).to eq(read_fixture('match_bet_scored.text').join)
    end
  end

  describe 'question_bet_scored' do
    let(:question) { create(:boolean_question, id: 2, number: 2, answer: 'true') }
    let!(:question_bet) { create(:boolean_question_bet, question: question, bet: bet) }
    let(:mail) { UsersMailer.question_bet_scored(question_bet.id, 0, 42) }
    it 'renders the headers' do
      expect(mail.subject).to eql("[#{ENV['APP_SHORT_NAME']}] Veja quantos pontos você fez na pergunta ##{question.number}")
      expect(mail.to).to eql([user.email])
      expect(mail.from).to eq([ENV['EMAIL_FROM']])
    end
    it 'renders the body' do
      expect(mail.body.to_s.chomp).to eq(read_fixture('question_bet_scored.text').join)
    end
  end

  def read_fixture(action)
    IO.readlines(File.join(Rails.root, 'spec', 'fixtures', self.class.mailer_class.name.underscore, "#{action}.#{I18n.locale}"))
  end

end
