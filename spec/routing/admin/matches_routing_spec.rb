require 'spec_helper'

describe Admin::MatchesController do

  describe '#index' do
    it { expect(get('/admin/matches')).to route_to(controller: 'admin/matches', action: 'index') }
    it { expect(admin_matches_path).to eq('/admin/matches') }
  end

  describe '#show' do
    it { expect(get('/admin/matches/42')).to route_to(controller: 'admin/matches', action: 'show', id: '42') }
    it { expect(admin_match_path(42)).to eq('/admin/matches/42') }
  end

  describe '#edit' do
    it { expect(get('/admin/matches/42/edit')).to route_to(controller: 'admin/matches', action: 'edit', id: '42') }
    it { expect(edit_admin_match_path(42)).to eq('/admin/matches/42/edit') }
  end

  describe '#update' do
    it { expect(put('/admin/matches/42')).to route_to(controller: 'admin/matches', action: 'update', id: '42') }
  end

end
