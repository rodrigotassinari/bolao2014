require "spec_helper"

describe Admin::NotificationsMailer do

  describe '.async_deliver' do
    it 'should delegate do EmailWorker, without params' do
      EmailWorker.should_receive(:perform_async).
        with(
          'Admin::NotificationsMailer',
          'payment_normal_change',
          []
        )
      described_class.async_deliver(:payment_normal_change)
    end
    it 'should delegate do EmailWorker, with one param' do
      EmailWorker.should_receive(:perform_async).
        with(
          'Admin::NotificationsMailer',
          'payment_normal_change',
          [42]
        )
      described_class.async_deliver(:payment_normal_change, 42)
    end
    it 'should delegate do EmailWorker, with multiple params' do
      EmailWorker.should_receive(:perform_async).
        with(
          'Admin::NotificationsMailer',
          'payment_normal_change',
          [42, 'paid', 'available']
        )
      described_class.async_deliver(:payment_normal_change, 42, 'paid', 'available')
    end
  end

  describe "payment_normal_change" do
    let(:mail) { Admin::NotificationsMailer.payment_normal_change }

    it "renders the headers" do
      mail.subject.should eq("Payment normal change")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "payment_strange_change" do
    let(:mail) { Admin::NotificationsMailer.payment_strange_change }

    it "renders the headers" do
      mail.subject.should eq("Payment strange change")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "payment_invalid_change" do
    let(:mail) { Admin::NotificationsMailer.payment_invalid_change }

    it "renders the headers" do
      mail.subject.should eq("Payment invalid change")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
