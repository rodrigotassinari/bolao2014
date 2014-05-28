require 'spec_helper'

describe User do

  context 'associations' do
    it { should have_one(:bet).dependent(:destroy) }
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
      user = build(:user, remember_me_token: nil)
      expect(user.remember_me_token).to be_nil
      user.save!
      expect(user.remember_me_token).to_not be_blank
    end
    it 'always sets the email as downcase' do
      user = build(:user, email: 'SomeOne@ExAmple.cOm')
      user.save!
      expect(user.email).to eql('someone@example.com')
    end
    it 'is not an admin' do
      user = build(:user)
      user.save!
      expect(user.admin).to be_false
    end
  end

  describe '#generate_authentication_token!' do
    it 'returns a new, 8 character, not ambiguous random temporary password' do
      user = build(:user)
      clear_text_password = user.generate_authentication_token!
      expect(clear_text_password).to_not be_blank
      expect(clear_text_password.size).to eq(8)
    end
    it 'sets a unique authentication_token' do
      user = create(:user)
      expect(user.authentication_token).to be_nil
      user.generate_authentication_token!
      expect(User.where(authentication_token: user.authentication_token).count).to eq(1)
    end
    it 'sets a authentication_token compatible with the temporary password' do
      user = create(:user)
      clear_text_password = user.generate_authentication_token!
      expect(user.validate_authentication_token!(clear_text_password)).to be_true
    end
    it 'sets a token expiration date 15 minutes in the future' do
      user = create(:user)
      expect(user.authentication_token_expires_at).to be_nil
      user.generate_authentication_token!
      expect(user.authentication_token_expires_at).to_not be_nil
      expect(user.authentication_token_expires_at).to be_between(14.minutes.from_now, 16.minutes.from_now)
    end
    it 'saves the user' do
      user = build(:user, email: 'someoneelse@example.com', locale: nil, time_zone: nil)
      user.set_defaults
      expect { user.generate_authentication_token! }.to change(User, :count).by(1)

      user = User.find(user.id)
      expect(user.email).to eql('someoneelse@example.com')
      expect(user.locale).to eql(I18n.locale.to_s)
      expect(user.time_zone).to eql(Time.zone.name)
      expect(user.bet).to_not be_nil
      expect(user.bet).to be_persisted
      expect(user.bet.points).to eql(0)
    end
  end

  describe '#authentication_token_expired?' do
    let!(:expiration) { Time.zone.now }
    context 'when user has no authentication_token' do
      let!(:user) { build(:user, authentication_token: nil, authentication_token_expires_at: nil) }
      it 'raises an error' do
        expect { user.authentication_token_expired? }.to raise_error(RuntimeError, 'authentication_token not set')
      end
    end
    context 'when user has an authentication_token' do
      let!(:user) { build(:user, authentication_token: 'foobar', authentication_token_expires_at: expiration) }
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
    let(:user) { create(:user, authentication_token: nil, authentication_token_expires_at: nil) }
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
        it 'returns true with the correct password (case insensitive) and resets the token' do
          expect(user.validate_authentication_token!(@clear_text_password.downcase)).to be_true
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
    it 'sets the user locale to the current locale', locale: :pt do
      expect(subject.locale).to be_nil
      subject.set_defaults
      expect(subject.locale).to eq('pt')
    end
    it 'sets the user time_zone to the current time_zone', time_zone: 'Auckland' do
      expect(subject.time_zone).to be_nil
      subject.set_defaults
      expect(subject.time_zone).to eq('Auckland')
    end
    it 'builds a Bet associated to the user' do
      expect(subject.bet).to be_nil
      subject.set_defaults
      expect(subject.bet).to_not be_nil
      expect(subject.bet.points).to eq(0)
    end
    it 'does not override any existing bet' do
      bet = build(:bet, user: subject, points: 42)
      subject.bet = bet
      subject.set_defaults
      expect(subject.bet).to_not be_nil
      expect(subject.bet).to equal(bet)
      expect(subject.bet.points).to eq(42)
    end
  end

end
