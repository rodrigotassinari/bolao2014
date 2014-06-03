require 'spec_helper'

describe QuestionScoreWorker do

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
    let!(:question) { create(:boolean_question) }
    it 'finds the question and scores it' do
      Question.should_receive(:find).with(question.id).and_return(question)
      question.should_receive(:score!)
      described_class.new.perform(question.id)
    end
  end

end
