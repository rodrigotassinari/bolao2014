require 'spec_helper'

describe SessionsMailer do
  describe 'one_time_login' do
    let(:user) do
      FactoryGirl.build(:user,
        name: 'Some Guy',
        email: 'some@guy.com',
        authentication_token_expires_at: 15.minutes.from_now
      )
    end
    let(:mail) { SessionsMailer.one_time_login(user, '12345678') }

    it 'renders the headers' do
      expect(mail.subject).to eq("[#{ENV['APP_NAME']}] Seu código de autenticação")
      expect(mail.to).to eq(['some@guy.com'])
      expect(mail.from).to eq([ENV['EMAIL_FROM']])
    end

    it 'renders the body' do
      expect(mail.body.parts.detect { |p| p.content_type =~ /plain/ }.body.to_s).to eq(read_fixture('one_time_login.text').join)
      expect(mail.body.parts.detect { |p| p.content_type =~ /html/  }.body.to_s).to eq(read_fixture('one_time_login.html').join)
    end
  end

  def read_fixture(action)
    IO.readlines(File.join(Rails.root, 'spec', 'fixtures', self.class.mailer_class.name.underscore, action))
  end

end
