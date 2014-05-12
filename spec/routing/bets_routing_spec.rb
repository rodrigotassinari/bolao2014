require 'spec_helper'

describe BetsController do

  describe '#show' do
    it { get('/bet').should route_to(controller: 'bets', action: 'show') }
    it { expect(bet_path).to eq('/bet') }
  end

end
