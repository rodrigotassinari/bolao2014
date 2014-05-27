require 'spec_helper'

describe BetPresenter do
  let(:user) { build(:user) }
  let(:bet) do
    build(:bet,
      id: 49,
      user: user,
      points: 33,
      created_at: '2014-06-12 17:00:00 -0300'.to_time,
      updated_at: '2014-06-13 17:00:00 -0300'.to_time
    )
  end
  subject { described_class.new(bet) }

  its(:to_key) { should eql([49]) }
  its(:to_param) { should eql('49') }
  its(:points) { should eql(33) }
  its(:created_at) { should eql('2014-06-12 17:00:00 -0300'.to_time) }
  its(:updated_at) { should eql('2014-06-13 17:00:00 -0300'.to_time) }

  it 'wraps associated user in a presenter' do
    expect(subject.user).to be_an_instance_of(UserPresenter)
    expect(subject.user.send(:subject)).to eq(user)
  end

  describe '#payment_status', locale: :pt do
    it 'returns paid' do
      bet.stub(:paid?).and_return(true)
      bet.stub(:paying?).and_return(false)
      expect(subject.payment_status).to eql('Paga')
    end
    it 'returns paying' do
      bet.stub(:paid?).and_return(false)
      bet.stub(:paying?).and_return(true)
      expect(subject.payment_status).to eql('Pagando')
    end
    it 'returns unpaid' do
      bet.stub(:paid?).and_return(false)
      bet.stub(:paying?).and_return(false)
      expect(subject.payment_status).to eql('Não paga')
    end
  end

end
