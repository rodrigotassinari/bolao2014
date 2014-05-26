require 'spec_helper'

describe BetsController do

  describe '#index' do
    it { expect(get('/bets')).to route_to(controller: 'bets', action: 'index') }
    it { expect(bets_path).to eq('/bets') }
  end

  describe '#show' do
    it { expect(get('/bets/42')).to route_to(controller: 'bets', action: 'show', id: '42') }
    it { expect(bet_path(42)).to eq('/bets/42') }
  end

end
