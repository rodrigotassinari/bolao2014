require 'spec_helper'

describe Player do

  context 'associations' do
     it { should belong_to(:team) }
  end

  context 'validations' do
    it { should validate_presence_of(:team) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:team_id) }

    it { should validate_presence_of(:position) }
    it { should ensure_inclusion_of(:position).in_array(Player::POSITIONS) }
  end

end
