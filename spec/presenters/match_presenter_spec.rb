require 'spec_helper'

describe MatchPresenter do
  let(:team_a) { build(:team, name_en: 'Brazil', name_pt: 'Brasil', acronym: 'BRA', group: 'A') }
  let(:team_b) { build(:other_team, name_en: 'Croatia', name_pt: 'Croácia', acronym: 'CRO', group: 'A') }
  let(:match) do
    build(:match,
      id: 49,
      number: 49,
      round: 'round_16',
      group: nil,
      played_at: '2014-06-12 17:00:00 -0300'.to_time,
      played_on: 'sp',
      team_a: team_a,
      team_b: team_b,
      goals_a: 2,
      goals_b: 2,
      penalty_goals_a: 4,
      penalty_goals_b: 3,
    )
  end
  subject { described_class.new(match) }

  its(:to_key) { should eql([49]) }
  its(:to_param) { should eql('49') }
  its(:number) { should eql(49) }
  its(:round) { should eql('round_16') }
  its(:group) { should be_nil }
  its(:played_at) { should eql('2014-06-12 17:00:00 -0300'.to_time) }
  its(:played_on) { should eql('sp') }
  its(:played_on_text) { should eql('Arena de São Paulo (Itaquerão), São Paulo, SP') }
  its(:goals_a) { should eql(2) }
  its(:goals_b) { should eql(2) }
  its(:penalty_goals_a) { should eql(4) }
  its(:penalty_goals_b) { should eql(3) }
  its(:team_a) { should eql(team_a) } # TODO wrap in presenter?
  its(:team_b) { should eql(team_b) } # TODO wrap in presenter?

end
