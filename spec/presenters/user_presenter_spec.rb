require 'spec_helper'

describe UserPresenter do
  let(:bet) { build(:bet) }
  let(:user) do
    build(:user,
      id: 22,
      name: 'Edson Arantes do Nascimento',
      email: 'pele@futebol.com.br',
      time_zone: 'Brasilia',
      locale: 'pt',
      created_at: '2014-06-12 17:00:00 -0300'.to_time,
      updated_at: '2014-06-13 17:00:00 -0300'.to_time,
      bet: bet
    )
  end
  subject { described_class.new(user) }

  its(:to_key) { should eql([22]) }
  its(:to_param) { should eql('22') }
  its(:name) { should eql('Edson Arantes do Nascimento') }
  its(:email) { should eql('pele@futebol.com.br') }
  its(:time_zone) { should eql('Brasilia') }
  its(:created_at) { should eql('2014-06-12 17:00:00 -0300'.to_time) }
  its(:updated_at) { should eql('2014-06-13 17:00:00 -0300'.to_time) }

  it 'wraps associated bet in a presenter' do
    expect(subject.bet).to be_an_instance_of(BetPresenter)
    expect(subject.bet.send(:subject)).to eq(bet)
  end

end
