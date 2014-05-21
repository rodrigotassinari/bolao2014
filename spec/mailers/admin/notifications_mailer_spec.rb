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

  describe "payment_normal_change", locale: :pt do
    let(:payment) { create(:paid_payment) }
    let(:mail) { Admin::NotificationsMailer.payment_normal_change(payment.id, 'waiting_payment', 'paid') }

    it "renders the headers" do
      expect(mail.subject).to eq("[#{ENV['APP_SHORT_NAME']} Admin] Pagamento ##{payment.id} atualizado")
      expect(mail.to).to eq([ ENV['APP_ADMIN_EMAIL'] ])
      expect(mail.from).to eq([ ENV['EMAIL_FROM'] ])
    end

    xit "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "payment_strange_change", locale: :pt do
    let(:payment) { create(:paid_payment) }
    let(:mail) { Admin::NotificationsMailer.payment_strange_change(payment.id, 'cancelled', 'paid') }

    it "renders the headers" do
      expect(mail.subject).to eq("[#{ENV['APP_SHORT_NAME']} Admin] Pagamento ##{payment.id} atualizado estranhamente (AVISO)")
      expect(mail.to).to eq([ ENV['APP_ADMIN_EMAIL'] ])
      expect(mail.from).to eq([ ENV['EMAIL_FROM'] ])
    end

    xit "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "payment_invalid_change", locale: :pt do
    let(:payment) { create(:paid_payment) }
    let(:mail) { Admin::NotificationsMailer.payment_invalid_change(payment.id, 'paid', 'waiting_payment') }

    it "renders the headers" do
      expect(mail.subject).to eq("[#{ENV['APP_SHORT_NAME']} Admin] Tentativa inválida de atualizar pagamento ##{payment.id} (ERRO)")
      expect(mail.to).to eq([ ENV['APP_ADMIN_EMAIL'] ])
      expect(mail.from).to eq([ ENV['EMAIL_FROM'] ])
    end

    xit "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  def read_fixture(action)
    IO.readlines(File.join(Rails.root, 'spec', 'fixtures', self.class.mailer_class.name.underscore, action))
  end

end
