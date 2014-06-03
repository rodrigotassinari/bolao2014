class BaseScoreWorker
  include Sidekiq::Worker
  sidekiq_options queue: :high, retry: true, backtrace: true

  def perform(subject_id)
    klass = self.class.to_s.split('ScoreWorker').first
    subject = klass.constantize.find(subject_id)
    subject.score!
  end

end
