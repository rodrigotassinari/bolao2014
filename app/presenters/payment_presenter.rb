class PaymentPresenter < Presenter

  expose :to_key, :to_param,
    :bet_id,
    :reference,
    :status,
    :amount,
    :paid_at,
    :checkout_code,
    :checkout_url,
    :transaction_code,
    :gross_amount,
    :discount_amount,
    :fee_amount,
    :net_amount,
    :extra_amount,
    :installments,
    :escrow_ends_at,
    :payer_name,
    :payer_email,
    :payer_phone,
    :created_at,
    :updated_at

  # TODO spec
  def css_id
    "payments_#{@subject.id}"
  end

  def bet
    @bet_presenter ||= BetPresenter.new(@subject.bet) if @subject.bet
  end

end
