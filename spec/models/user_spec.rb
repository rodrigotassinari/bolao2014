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
    it 'returns a new, 8 character, not ambiguous random temporary password' do
      user = FactoryGirl.build(:user)
      clear_text_password = user.generate_authentication_token!
      expect(clear_text_password).to_not be_blank
      expect(clear_text_password.size).to eq(8)
    end
    it 'sets a unique authentication_token' do
      user = FactoryGirl.create(:user)
      expect(user.authentication_token).to be_nil
      user.generate_authentication_token!
      expect(User.where(authentication_token: user.authentication_token).count).to eq(1)
    end
    it 'sets a authentication_token compatible with the temporary password' do
      user = FactoryGirl.create(:user)
      clear_text_password = user.generate_authentication_token!
      expect(user.validate_authentication_token!(clear_text_password)).to be_true
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

  describe '#authentication_token_expired?' do
    let!(:expiration) { Time.zone.now }
    context 'when user has no authentication_token' do
      let!(:user) { FactoryGirl.build(:user, authentication_token: nil, authentication_token_expires_at: nil) }
      it 'raises an error' do
        expect { user.authentication_token_expired? }.to raise_error(RuntimeError, 'authentication_token not set')
      end
    end
    context 'when user has an authentication_token' do
      let!(:user) { FactoryGirl.build(:user, authentication_token: 'foobar', authentication_token_expires_at: expiration) }
      it 'returns false if authentication_token_expires_at is in the future' do
        Timecop.freeze(expiration - 14.minutes) do
          expect(user.authentication_token_expired?).to be_false
        end
      end
      it 'returns false if authentication_token_expires_at is now' do
        Timecop.freeze(expiration) do
          expect(user.authentication_token_expired?).to be_false
        end
      end
      it 'returns true if authentication_token_expires_at is in the past' do
        Timecop.freeze(expiration + 1.second) do
          expect(user.authentication_token_expired?).to be_true
        end
      end
    end
  end

  describe '#validate_authentication_token!' do
    let(:user) { FactoryGirl.create(:user, authentication_token: nil, authentication_token_expires_at: nil) }
    context 'when user has no authentication_token' do
      it 'returns false' do
        expect(user.validate_authentication_token!('any password')).to be_false
      end
    end
    context 'when user has an authentication_token' do
      before(:each) do
        @clear_text_password = user.generate_authentication_token!
      end
      context 'when authentication_token is valid (has not expired)' do
        before(:each) do
          user.should_receive(:authentication_token_expired?).and_return(false)
          expect(user.authentication_token_exists?).to be_true
        end
        it 'returns false with the wrong password and resets the token' do
          expect(user.validate_authentication_token!('wrong password')).to be_false
          expect(user.authentication_token_exists?).to be_false
        end
        it 'returns true with the correct password and resets the token' do
          expect(user.validate_authentication_token!(@clear_text_password)).to be_true
          expect(user.authentication_token_exists?).to be_false
        end
      end
      context 'when authentication_token is invalid (has expired)' do
        before(:each) do
          user.should_receive(:authentication_token_expired?).and_return(true)
          expect(user.authentication_token_exists?).to be_true
        end
        it 'returns false with the wrong password and resets the token' do
          expect(user.validate_authentication_token!('wrong password')).to be_false
          expect(user.authentication_token_exists?).to be_false
        end
        it 'returns false with the correct password and resets the token' do
          expect(user.validate_authentication_token!(@clear_text_password)).to be_false
          expect(user.authentication_token_exists?).to be_false
        end
      end
    end
  end

  describe '#set_defaults' do
    it 'sets the user locale to the current locale', locale: :en do
      expect(subject.locale).to be_nil
      subject.set_defaults
      expect(subject.locale).to eq('en')
    end
    it 'sets the user time_zone to the current time_zone', time_zone: 'Auckland' do
      expect(subject.time_zone).to be_nil
      subject.set_defaults
      expect(subject.time_zone).to eq('Auckland')
    end
  end

end
