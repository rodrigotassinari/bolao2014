require 'spec_helper'

describe DashboardController do
  describe '#new' do
    it { get('/').should route_to(controller: 'dashboard', action: 'index') }
    it { expect(root_path).to eq('/') }
  end
end
