require 'spec_helper'

describe MatchBetPresenter do
  let(:bet) { build(:bet) }
  let(:team_a) { build(:team, id: 42, name_en: 'Brazil', name_pt: 'Brasil', acronym: 'BRA', group: 'A') }
  let(:team_b) { build(:other_team, id: 24, name_en: 'Croatia', name_pt: 'Croácia', acronym: 'CRO', group: 'A') }
  let(:match) { build(:match, team_a: team_a, team_b: team_b) }
  let(:match_bet) do
    build(:match_bet,
      id: 49,
      bet: bet,
      match: match,
      goals_a: 3,
      goals_b: 3,
      penalty_winner_id: match.team_a.id,
      points: 33,
      created_at: '2014-06-12 17:00:00 -0300'.to_time,
      updated_at: '2014-06-13 17:00:00 -0300'.to_time
    )
  end
  subject { described_class.new(match_bet) }

  its(:to_key) { should eql([49]) }
  its(:to_param) { should eql('49') }
  its(:goals_a) { should eql(3) }
  its(:goals_b) { should eql(3) }
  its(:penalty_winner_id) { should eql(42) }
  its(:points) { should eql(33) }
  its(:created_at) { should eql('2014-06-12 17:00:00 -0300'.to_time) }
  its(:updated_at) { should eql('2014-06-13 17:00:00 -0300'.to_time) }
  its(:bet) { should eql(bet) } # TODO wrap in presenter
  its(:match) { should be_an_instance_of(MatchPresenter) }

end
