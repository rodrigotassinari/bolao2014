require 'spec_helper'

describe MatchesController do

  describe '#index' do
    it { expect(get('/matches')).to route_to(controller: 'matches', action: 'index') }
    it { expect(matches_path).to eq('/matches') }
  end

  describe '#show' do
    it { expect(get('/matches/42')).to route_to(controller: 'matches', action: 'show', id: '42') }
    it { expect(match_path(42)).to eq('/matches/42') }
  end

end
