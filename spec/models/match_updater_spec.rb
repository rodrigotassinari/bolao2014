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

  describe '#save' do
    # TODO
  end

  describe '#message' do
    # TODO
  end

end
