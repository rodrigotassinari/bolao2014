require 'spec_helper'

describe Team do

  context 'associations' do
    it { should have_many(:matches_as_a).class_name('Match').with_foreign_key('team_a_id') }
    it { should have_many(:matches_as_b).class_name('Match').with_foreign_key('team_b_id') }
    # it { should have_many(:matches).class_name('Match') }

    it { should have_many(:players) }
  end

  context 'validations' do
    it { should validate_presence_of(:name_en) }
    it { should validate_uniqueness_of(:name_en).case_insensitive }
    it { should validate_presence_of(:name_pt) }
    it { should validate_uniqueness_of(:name_pt).case_insensitive }
    it { should validate_presence_of(:acronym) }
    it { should validate_uniqueness_of(:acronym).case_insensitive }
    it { should validate_presence_of(:group) }
    it { should ensure_inclusion_of(:group).in_array(Match::GROUPS) }
  end

  describe '#name' do
    subject { build(:team) }
    it 'returns the :pt name', locale: :pt do
      expect(subject.name).to eql('Brasil')
    end
    it 'returns the :en name', locale: :en do
      expect(subject.name).to eql('Brazil')
    end
  end

end
