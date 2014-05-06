require 'spec_helper'

describe User do

  context 'factories' do
    [:user, :user_en, :user_pt].each do |factory_name|
      subject { FactoryGirl.build(factory_name) }
      it "has a valid '#{factory_name}' factory" do
        expect(subject).to be_valid
      end
    end
  end

  context 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:locale) }
    it { should validate_presence_of(:time_zone) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_uniqueness_of(:remember_me_token) }
    it { should validate_uniqueness_of(:authentication_token) }
    it do
      should allow_value(
        'foo@example.com', 'foo.bar@example.com.br',
        'foo+bar@example.com', 'foo-bar_baz@example.br'
      ).for(:email)
    end
    it do
      should_not allow_value('example.com').for(:email)
      should_not allow_value('foo.bar.example.com.br').for(:email)
      should_not allow_value('foo bar@example.com').for(:email)
      should_not allow_value('foo-bar_baz@example').for(:email)
    end
    it { should ensure_inclusion_of(:time_zone).in_array(ActiveSupport::TimeZone.all.map(&:name)) }
    it { should ensure_inclusion_of(:locale).in_array(I18n.available_locales.map(&:to_s)) }
  end

  context 'when creating a new user' do
    it 'sets a random remember_me_token' do
      user = FactoryGirl.build(:user, remember_me_token: nil)
      # user = FactoryGirl.build(:user)
      expect(user.remember_me_token).to be_nil
      user.save!
      expect(user.remember_me_token).to_not be_blank
    end
  end

  describe '#generate_authentication_token!' do
    it 'sets a new, unique, 8 character, not ambiguous random token' do
      user = FactoryGirl.create(:user)
      expect(user.authentication_token).to be_nil
      user.generate_authentication_token!
      expect(user.authentication_token).to_not be_blank
      expect(user.authentication_token.size).to eq(8)
      expect(User.where(authentication_token: user.authentication_token).count).to eq(1)
    end
    it 'sets a token expiration date 15 minutes in the future' do
      user = FactoryGirl.create(:user)
      expect(user.authentication_token_expires_at).to be_nil
      user.generate_authentication_token!
      expect(user.authentication_token_expires_at).to_not be_nil
      expect(user.authentication_token_expires_at).to be_between(14.minutes.from_now, 16.minutes.from_now)
    end
    it 'saves the user' do
      user = FactoryGirl.build(:user)
      expect { user.generate_authentication_token! }.to change(User, :count).by(1)
    end
  end

end
