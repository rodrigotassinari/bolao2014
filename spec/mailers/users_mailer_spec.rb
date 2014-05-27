require 'spec_helper'

describe UsersMailer do
  let(:user) { create(:user) }
  let(:bet) { create(:bet, user: user) }

  describe ".send_match_bet_reminder" do
    let!(:bet2) { create(:bet, user: create(:user, email: 'bill@gates.com')) }
    let!(:bet3) { create(:bet, user: create(:user, email: 'jobs@apple.com')) }
    let(:time_before) { 8 }
    let!(:bettable_match1) { create(:match, played_at: Time.parse("2014-05-26 09:00:00 -0300")) }
    let!(:bettable_match2) { create(:match, number: 3, team_a: Team.first, team_b: Team.last, played_at: Time.parse("2014-05-26 09:00:01 -0300")) }
    let!(:match_bet_1) { create(:match_bet, bet: bet3, match: bettable_match1) }
    before { bet.save! }

    it "notifies users who have matches without bet and these matches will be locked in less then 8 hours" do
      Timecop.freeze(Time.parse("2014-05-26 00:00:00 -0300")) do
        UsersMailer.should_receive(:async_deliver).with('match_bet_reminder', bettable_match1.id, bet.id)
        UsersMailer.should_receive(:async_deliver).with('match_bet_reminder', bettable_match1.id, bet2.id)
        UsersMailer.send_match_bet_reminder(time_before)
      end
    end
  end

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

  describe "match_bet_reminder" do
    let(:team_a) { create(:team) }
    let(:team_b) { create(:other_team) }
    let(:match) { create(:match, id: 1, number: 1, team_a: team_a, team_b: team_b) }
    let(:mail) { UsersMailer.match_bet_reminder(match.id, bet.id) }
    it 'renders the headers' do
      expect(mail.subject).to eql("[#{ENV['APP_SHORT_NAME']}] Você ainda não deu o seu palpite para a partida ##{match.number}")
      expect(mail.to).to eql([user.email])
      expect(mail.from).to eq([ENV['EMAIL_FROM']])
    end
    it 'renders the body' do
      expect(mail.body.to_s.chomp).to eq(read_fixture('match_bet_reminder.text').join)
    end
  end

  def read_fixture(action)
    IO.readlines(File.join(Rails.root, 'spec', 'fixtures', self.class.mailer_class.name.underscore, "#{action}.#{I18n.locale}"))
  end

end
