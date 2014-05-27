require 'spec_helper'

describe PaymentsController do

  describe '#new' do
    it { expect(get('/my_bet/payment')).to route_to(controller: 'payments', action: 'new') }
    it { expect(my_bet_payment_path).to eq('/my_bet/payment') }
  end

  describe '#create' do
    it { expect(post('/my_bet/payment')).to route_to(controller: 'payments', action: 'create') }
    it { expect(my_bet_payment_path).to eq('/my_bet/payment') }
  end

  describe '#update' do
    it { expect(post('/payment_notifications')).to route_to(controller: 'payments', action: 'update') }
    it { expect(payment_notifications_path).to eq('/payment_notifications') }
  end

end
