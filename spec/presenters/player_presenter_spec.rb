require 'spec_helper'

describe PlayerPresenter do
  let(:team) { build(:team) }
  let(:player) do
    build(:goal_player,
      id: 49,
      name: 'Beltrano da Silva',
      position: 'goalkeeper',
      team: team
    )
  end
  subject { described_class.new(player) }

  its(:to_key) { should eql([49]) }
  its(:to_param) { should eql('49') }
  its(:name) { should eql('Beltrano da Silva') }
  its(:position) { should eql('goalkeeper') }

  it 'wraps associated team in a presenter' do
    expect(subject.team).to be_an_instance_of(TeamPresenter)
    expect(subject.team.send(:subject)).to eq(team)
  end

end
