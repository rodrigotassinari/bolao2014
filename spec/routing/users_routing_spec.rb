require 'spec_helper'

describe UsersController do

  describe '#edit' do
    it { expect(get('/profile')).to route_to(controller: 'users', action: 'edit') }
    it { expect(profile_path).to eq('/profile') }
  end

  describe '#update' do
    it { expect(put('/profile')).to route_to(controller: 'users', action: 'update') }
  end

end
