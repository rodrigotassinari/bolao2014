require 'spec_helper'

describe MatchScoreWorker do

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
    let!(:match) { create(:match) }
    it 'finds the match and scores it' do
      Match.should_receive(:find).with(match.id).and_return(match)
      match.should_receive(:score!)
      described_class.new.perform(match.id)
    end
  end

end
