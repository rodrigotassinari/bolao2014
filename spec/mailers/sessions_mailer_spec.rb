require 'spec_helper'

describe SessionsMailer do
  describe 'one_time_login' do
    let(:user) do
      build(:user,
        id: 42,
        name: 'Some Guy',
        email: 'some@guy.com',
        authentication_token_expires_at: 15.minutes.from_now
      )
    end
    let(:mail) { SessionsMailer.one_time_login(user.id, '12345678') }
    before(:each) do
      User.should_receive(:find).with(42).and_return(user)
    end

    it 'renders the headers', locale: :pt do
      expect(mail.subject).to eq("[#{ENV['APP_SHORT_NAME']}] Seu código de acesso")
      expect(mail.to).to eq(['some@guy.com'])
      expect(mail.from).to eq([ENV['EMAIL_FROM']])
    end

    it 'renders the body', locale: :pt do
      current_app_name = ENV['APP_NAME']
      ENV['APP_NAME'] = 'Bolão 2014'
      expect(mail.body.to_s.chomp).to eq(read_fixture('one_time_login.text').join)
      ENV['APP_NAME'] = current_app_name
    end
  end

  def read_fixture(action)
    IO.readlines(File.join(Rails.root, 'spec', 'fixtures', self.class.mailer_class.name.underscore, action))
  end

end
