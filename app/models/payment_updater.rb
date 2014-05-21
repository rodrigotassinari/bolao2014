class PaymentUpdater

  attr_reader :transaction, :payment

  def initialize(transaction=PagSeguro::Transaction.new, payment_class=Payment)
    @transaction = transaction
    @payment = payment_class.find_by_reference!(transaction.reference)
  end

  def update!
    # TODO
    raise 'oops'
  end

end
