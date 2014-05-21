# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :initiated_payment, class: Payment do
    association :bet, factory: :bet, strategy: :build

    status 'initiated'
    amount 25.00

    after(:build) do |payment|
      if payment.bet.present? && payment.reference.blank?
        payment.reference = "bet_#{payment.bet.id}"
      end
    end
  end

  factory :unpaid_payment, class: Payment do
    association :bet, factory: :bet, strategy: :build

    status 'waiting_payment'
    amount 25.00
    checkout_code '7CA214DA8989C26884856F99EFAFC4E6'
    checkout_url 'https://sandbox.pagseguro.uol.com.br/v2/checkout/payment.html?code=7CA214DA8989C26884856F99EFAFC4E6'

    after(:build) do |payment|
      if payment.bet.present? && payment.reference.blank?
        payment.reference = "bet_#{payment.bet.id}"
      end
    end
  end

  factory :paid_payment, class: Payment do
    association :bet, factory: :bet, strategy: :build

    status 'paid'
    amount 25.00
    checkout_code '7CA214DA8989C26884856F99EFAFC4E6'
    checkout_url 'https://sandbox.pagseguro.uol.com.br/v2/checkout/payment.html?code=7CA214DA8989C26884856F99EFAFC4E6'
    paid_at Time.zone.now
    transaction_code 'D0DCE84E20AF41A68C6070F79815D610'
    gross_amount 25.00
    discount_amount 0.00
    fee_amount 1.65
    net_amount 23.35
    extra_amount 0.00
    installments 1
    escrow_ends_at 14.days.from_now
    payer_name 'Comprador Virtual'
    payer_email 'c12405103904896784873@sandbox.pagseguro.com.br'
    payer_phone '11 99999999'

    after(:build) do |payment|
      if payment.bet.present? && payment.reference.blank?
        payment.reference = "bet_#{payment.bet.id}"
      end
    end
  end
end
