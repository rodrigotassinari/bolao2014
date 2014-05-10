require 'spec_helper'

describe Team do

  context 'validations' do
    it { should validate_presence_of(:name_en) }
    it { should validate_uniqueness_of(:name_en).case_insensitive }
    it { should validate_presence_of(:name_pt) }
    it { should validate_uniqueness_of(:name_pt).case_insensitive }
    it { should validate_presence_of(:acronym) }
    it { should validate_uniqueness_of(:acronym).case_insensitive }
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
