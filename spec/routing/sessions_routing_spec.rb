require 'spec_helper'

describe SessionsController do
  describe '#new' do
    it { expect(get('/login')).to route_to(controller: 'sessions', action: 'new') }
    it { expect(login_path).to eq('/login') }
  end

  describe '#one_time_token' do
    it { expect(post('/one_time_token')).to route_to(controller: 'sessions', action: 'one_time_token') }
    it { expect(one_time_token_path).to eq('/one_time_token') }
  end

  describe '#create' do
    it { expect(post('/login')).to route_to(controller: 'sessions', action: 'create') }
  end

  describe '#destroy' do
    it { expect(get('/logout')).to route_to(controller: 'sessions', action: 'destroy') }
    it { expect(logout_path).to eq('/logout') }
  end
end
