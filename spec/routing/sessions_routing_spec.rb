require 'spec_helper'

describe SessionsController do
  describe '#new' do
    it { get('/login').should route_to(controller: 'sessions', action: 'new') }
    it { expect(login_path).to eq('/login') }
  end

  describe '#one_time_token' do
    it { post('/one_time_token').should route_to(controller: 'sessions', action: 'one_time_token') }
    it { expect(one_time_token_path).to eq('/one_time_token') }
  end

  describe '#create' do
    it { post('/login').should route_to(controller: 'sessions', action: 'create') }
  end

  describe '#destroy' do
    it { get('/logout').should route_to(controller: 'sessions', action: 'destroy') }
    it { expect(logout_path).to eq('/logout') }
  end
end
