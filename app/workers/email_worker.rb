class EmailWorker
  include Sidekiq::Worker
  sidekiq_options queue: :high, retry: true, backtrace: true

  def perform(mailer_class, mailer_action, args=[])
    mailer_class.constantize.send(mailer_action, *args).deliver
  end

end
