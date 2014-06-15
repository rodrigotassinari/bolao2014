require 'spec_helper'

describe Admin::MatchesController do

  describe '#edit' do
    it { expect(get('/admin/matches/42/edit')).to route_to(controller: 'admin/matches', action: 'edit', id: '42') }
    it { expect(edit_admin_match_path(42)).to eq('/admin/matches/42/edit') }
  end

  describe '#update' do
    it { expect(put('/admin/matches/42')).to route_to(controller: 'admin/matches', action: 'update', id: '42') }
  end

end
