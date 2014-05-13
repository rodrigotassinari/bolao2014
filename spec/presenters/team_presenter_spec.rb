require 'spec_helper'

describe TeamPresenter do
  let(:team) do
    build(:team,
      id: 22,
      name_en: 'Italy',
      name_pt: 'Itália',
      acronym: 'ITA',
      group: 'D'
    )
  end
  subject { described_class.new(team) }

  its(:to_key) { should eql([22]) }
  its(:to_param) { should eql('22') }
  its(:name) { should eql('Itália') } # locale: :pt
  its(:name_en) { should eql('Italy') }
  its(:name_pt) { should eql('Itália') }
  its(:acronym) { should eql('ITA') }
  its(:group) { should eql('D') }

end
