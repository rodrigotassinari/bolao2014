require 'spec_helper'

describe MatchBetPresenter do
  let(:bet) { build(:bet) }
  let(:team_a) { create(:team, name_en: 'Brazil', name_pt: 'Brasil', acronym: 'BRA', group: 'A') }
  let(:team_b) { create(:other_team, name_en: 'Croatia', name_pt: 'Croácia', acronym: 'CRO', group: 'A') }
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
  its(:penalty_winner_id) { should eql(match.team_a.id) }
  its(:points) { should eql(33) }
  its(:created_at) { should eql('2014-06-12 17:00:00 -0300'.to_time) }
  its(:updated_at) { should eql('2014-06-13 17:00:00 -0300'.to_time) }

  it 'wraps associated match in a presenter' do
    expect(subject.match).to be_an_instance_of(MatchPresenter)
    expect(subject.match.send(:subject)).to eq(match)
  end

  it 'wraps associated bet in a presenter' do
    expect(subject.bet).to be_an_instance_of(BetPresenter)
    expect(subject.bet.send(:subject)).to eq(bet)
  end

  describe '#one_line_summary', locale: :pt do
    it 'returns a string with all information of the match_bet with penalty information' do
      expect(subject.one_line_summary).to eql('Brasil 3 x 3 Croácia, com Brasil ganhando nos pênaltis')
    end
    it 'returns a string with all information of the match_bet when draw' do
      match_bet.penalty_winner_id = nil
      expect(subject.one_line_summary).to eql('Brasil 3 x 3 Croácia')
    end
    it 'returns a string with all information of the match_bet when normal victory' do
      match_bet.penalty_winner_id = nil
      match_bet.goals_b = 2
      expect(subject.one_line_summary).to eql('Brasil 3 x 2 Croácia')
    end
  end

end
