class EmailWorker
  include Sidekiq::Worker
  sidekiq_options queue: :high, retry: true, backtrace: true

  def perform(mailer_class, mailer_action, args=[])
    if (args.nil? || args.empty?)
      mailer_class.constantize.send(mailer_action).deliver
    else
      mailer_class.constantize.send(mailer_action, *args).deliver
    end
  end

end
