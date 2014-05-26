require 'spec_helper'

describe MatchPresenter do
  let(:team_a) { create(:team, name_en: 'Brazil', name_pt: 'Brasil', acronym: 'BRA', group: 'A') }
  let(:team_b) { create(:other_team, name_en: 'Croatia', name_pt: 'Croácia', acronym: 'CRO', group: 'A') }
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

  it 'wraps associated team_a in a presenter' do
    expect(subject.team_a).to be_an_instance_of(TeamPresenter)
    expect(subject.team_a.send(:subject)).to eq(team_a)
  end

  it 'wraps associated team_b in a presenter' do
    expect(subject.team_b).to be_an_instance_of(TeamPresenter)
    expect(subject.team_b.send(:subject)).to eq(team_b)
  end

  describe 'one_line_summary', locale: :pt do
    it 'returns a string with all information of the match with penalty information' do
      expect(subject.one_line_summary).to eql('Brasil 2 x 2 Croácia, nos pênaltis Brasil 4 x 3 Croácia')
    end
    it 'returns a string with all information of the match when draw' do
      match.penalty_goals_a = nil
      match.penalty_goals_b = nil
      expect(subject.one_line_summary).to eql('Brasil 2 x 2 Croácia')
    end
    it 'returns a string with all information of the match when normal victory' do
      match.penalty_goals_a = nil
      match.penalty_goals_b = nil
      match.goals_b = 1
      expect(subject.one_line_summary).to eql('Brasil 2 x 1 Croácia')
    end
  end

end
