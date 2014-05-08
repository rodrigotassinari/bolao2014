require 'spec_helper'

describe OneTimeLogin do

  describe '.find_user' do
    context 'when a user with that email exists' do
      let!(:existing_user) { FactoryGirl.create(:user_en) }
      let(:user) { described_class.find_user(existing_user.email) }
      it 'returns the user, without changing it' do
        expect(user).to be_persisted
        expect(user).to eql(existing_user)
      end
    end
    context 'when no user exists with that email' do
      let(:user) { described_class.find_user('someone@example.com') }
      it 'returns the a new user, without saving it' do
        expect(user).to_not be_persisted
      end
      it 'sets default values on the new user' do
        expect(user.locale).to eq(I18n.locale.to_s)
        expect(user.time_zone).to eq(Time.zone.name)
      end
    end
  end

  describe '#valid?' do
    subject { described_class.new(user) }
    context 'with a valid user' do
      let(:user) { FactoryGirl.build(:user) }
      it 'returns true' do
        expect(subject).to be_valid
      end
    end
    context 'without a user' do
      let(:user) { nil }
      it 'returns false' do
        expect(subject).to_not be_valid
      end
      it 'sets error messages', locale: :pt do
        subject.valid?
        expect(subject.errors).to be_an_instance_of(ActiveModel::Errors)
        expect(subject.errors.full_messages).to eq(['User cannot be nil']) # TODO translate
      end
    end
    context 'with an invalid user' do
      let(:user) { FactoryGirl.build(:user, email: 'invalid email') }
      it 'returns false' do
        expect(subject).to_not be_valid
      end
      it 'sets error messages', locale: :pt do
        subject.valid?
        expect(subject.errors).to be_an_instance_of(ActiveModel::Errors)
        expect(subject.errors.full_messages).to eq(['User is invalid']) # TODO translate
      end
    end
  end

end
