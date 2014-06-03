require 'spec_helper'

describe MatchUpdater do

  describe '.new' do
    let(:match) { build(:match) }
    let(:changes) { {'goals_a'=>'2', 'goals_b'=>'1'} }
    it 'instanciates a new updater with the match and changes set' do
      updater = described_class.new(match, changes)
      expect(updater.match).to eql(match)
      expect(updater.changes).to eql(changes)
      updater.changes = {}
      expect(updater.changes).to be_empty
    end
  end

  describe '#valid?' do
    it 'raises an error when match is new record' do
      match = build(:match)
      updater = described_class.new(match, {'goals_a'=>'2', 'goals_b'=>'1'})
      expect { updater.valid? }.to raise_error(ArgumentError, 'match is not persisted')
    end
    it 'raises an error when there is nothing to change on the match' do
      match = create(:match)
      updater = described_class.new(match, {})
      expect { updater.valid? }.to raise_error(ArgumentError, 'nothing to change on the match')
    end
    it 'returns true' do
      match = create(:match)
      updater = described_class.new(match, {'goals_a'=>'2', 'goals_b'=>'1'})
      expect(updater.valid?).to be_true
    end
  end

  describe '#save' do
    let(:team_a) { create(:team) }
    let(:team_b) { create(:other_team) }
    let(:group_match) { create(:match, round: 'group', team_a: team_a, team_b: team_b, goals_a: nil, goals_b: nil) }
    let(:finals_match) { create(:future_match, round: 'quarter', team_a: nil, team_b: nil, goals_a: nil, goals_b: nil) }
    let(:scored_match) { create(:match, round: 'group', team_a: team_a, team_b: team_b, goals_a: 2, goals_b: 1) }
    context 'when match is not changed' do
      it 'returns false' do
        updater = described_class.new(group_match, {'played_on' => group_match.played_on}) # no real change
        expect(updater.save).to be_false
        expect(updater.message).to be_nil
      end
      it 'returns the errors', locale: :pt do
        updater = described_class.new(finals_match, {'team_a_id' => team_a.id.to_s, 'team_b_id' => team_a.id.to_s}) # invalid change
        expect(updater.save).to be_false
        expect(updater.message).to be_nil
        expect(updater.errors).to_not be_empty
        expect(updater.errors.get(:team_b_id)).to eq(['não pode ser o mesmo que o outro'])
      end
    end
    context 'when match is changed', locale: :pt do
      it 'changes the match' do
        expect(group_match.goals_a).to be_nil
        expect(group_match.goals_b).to be_nil
        updater = described_class.new(group_match, {'goals_a' => '2'})
        expect(updater.save).to be_true
        expect(updater.message).to eq('Partida alterada.')
        expect(group_match.goals_a).to eq(2)
        expect(group_match.goals_b).to be_nil
      end
      it 'notify users if match becomes bettable' do
        user1 = create(:admin_user)
        user2 = create(:user)
        UsersMailer.should_receive(:async_deliver).with(:match_bettable_notification, finals_match.id, user1.id)
        UsersMailer.should_receive(:async_deliver).with(:match_bettable_notification, finals_match.id, user2.id)

        expect(finals_match).to_not be_bettable
        updater = described_class.new(finals_match, {'team_a_id' => team_a.id.to_s, 'team_b_id' => team_b.id.to_s})
        expect(updater.save).to be_true
        expect(updater.message).to eq('Partida alterada. Apostadores notificados sobre nova disponibilidade de palpites nesta partida.')
        expect(finals_match).to be_bettable
      end
      it 'does not notify users if match was already bettable' do
        user1 = create(:admin_user)
        user2 = create(:user)
        UsersMailer.should_not_receive(:async_deliver)

        expect(group_match).to be_bettable
        updater = described_class.new(group_match, {'goals_a' => '2', 'goals_b' => '1'})
        expect(updater.save).to be_true
        expect(updater.message).to eq('Partida alterada.')
        expect(group_match).to be_bettable
      end
      it 'does not notify users if match does not become bettable' do
        user1 = create(:admin_user)
        user2 = create(:user)
        UsersMailer.should_not_receive(:async_deliver)

        expect(finals_match).to_not be_bettable
        updater = described_class.new(finals_match, {'team_a_id' => team_a.id.to_s, 'team_b_id' => ''})
        expect(updater.save).to be_true
        expect(updater.message).to eq('Partida alterada.')
        expect(finals_match).to_not be_bettable
      end
      it 'scores the match if match becomes scorable' do
        group_match.stub(:locked?).and_return(true)
        MatchScoreWorker.should_receive(:perform_async).with(group_match.id)

        expect(group_match).to_not be_scorable
        updater = described_class.new(group_match, {'goals_a' => '2', 'goals_b' => '1'})
        expect(updater.save).to be_true
        expect(updater.message).to eq('Partida alterada. Pontos de palpites sobre esta partida (re-)calculados.')
        expect(group_match).to be_scorable
      end
      it 'does not score the match if match does not become scorable' do
        group_match.stub(:locked?).and_return(true)
        MatchScoreWorker.should_not_receive(:perform_async)

        expect(group_match).to_not be_scorable
        updater = described_class.new(group_match, {'goals_a' => '2', 'goals_b' => ''})
        expect(updater.save).to be_true
        expect(updater.message).to eq('Partida alterada.')
        expect(group_match).to_not be_scorable
      end
    end
  end

end
