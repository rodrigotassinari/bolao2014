require 'spec_helper'

describe UsersMailer do

  describe 'match_bet_scored' do
    let(:mail) { UsersMailer.match_bet_scored }

    it 'renders the headers' do
      expect(mail.subject).to eql('Match bet scored')
      expect(mail.to).to eql(['to@example.org'])
      expect(mail.from).to eql(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
    end
  end

  describe 'question_bet_scored' do
    let(:mail) { UsersMailer.question_bet_scored }

    it 'renders the headers' do
      expect(mail.subject).to eql('Question bet scored')
      expect(mail.to).to eql(['to@example.org'])
      expect(mail.from).to eql(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
    end
  end

end
