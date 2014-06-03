require 'spec_helper'

describe BetScoreWorker do

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
    let!(:bet) { create(:bet) }
    it 'finds the bet and scores it' do
      Bet.should_receive(:find).with(bet.id).and_return(bet)
      bet.should_receive(:score!)
      described_class.new.perform(bet.id)
    end
  end

end
