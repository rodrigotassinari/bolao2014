require 'spec_helper'

describe MatchesController do

  describe '#index' do
    it { get('/matches').should route_to(controller: 'matches', action: 'index') }
    it { expect(matches_path).to eq('/matches') }
  end

  describe '#show' do
    it { get('/matches/42').should route_to(controller: 'matches', action: 'show', id: '42') }
    it { expect(match_path(42)).to eq('/matches/42') }
  end

end
