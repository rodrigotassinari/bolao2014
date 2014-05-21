class PagseguroTransactionWorker
  include Sidekiq::Worker
  sidekiq_options queue: :low, retry: true, backtrace: true

  def perform(notification_code)
    transaction = PagSeguro::Transaction.find_by_notification_code(notification_code)
    if transaction.errors.empty?
      PaymentUpdater.new(transaction).update!
    else
      # there's something wrong at PagSeguro
      raise "something wrong at PagSeguro, notification_code=#{notification_code}, errors: #{transaction.errors.join(',')}"
    end
  end
end
