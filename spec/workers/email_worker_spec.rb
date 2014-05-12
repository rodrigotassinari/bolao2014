require 'spec_helper'

describe EmailWorker do

  it 'uses the `high` queue' do
    expect(described_class.get_sidekiq_options['queue']).to eq(:high)
  end

  it 'is retryable' do
    expect(described_class.get_sidekiq_options['retry']).to be_true
  end

  it 'saves error backtrace to show on the web ui' do
    expect(described_class.get_sidekiq_options['backtrace']).to be_true
  end

  describe '#perform' do
    it 'calls the method from the class defined with params' do
      mailer = double(SessionsMailer)
      mailer_as_string = 'SessionsMailer'
      mailer_as_string.should_receive(:constantize) { SessionsMailer }
      SessionsMailer.should_receive(:one_time_login).with(42, 'password') { mailer }
      mailer.should_receive(:deliver)

      job = EmailWorker.new
      job.perform(mailer_as_string, 'one_time_login', [42, 'password'])
    end
  end

end
