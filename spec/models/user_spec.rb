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

end
