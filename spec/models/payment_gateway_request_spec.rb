require 'spec_helper'

describe PaymentGatewayRequest do
  let(:bet) { create(:bet) }
  let(:payment) { create(:initiated_payment, bet: bet) }
  subject { described_class.new(payment) }

  describe '.new' do
    it 'sets the payment attribute' do
      expect(subject.payment).to eql(payment)
    end
    it 'has no errors' do
      expect(subject.errors).to be_empty
    end
    it 'sets the gateway_request attribute, with values from the payment', locale: :pt do
      request = subject.gateway_request
      expect(request).to_not be_nil
      expect(request).to be_instance_of(PagSeguro::PaymentRequest)
      expect(request.reference).to eql(payment.reference)
      expect(request.notification_url).to eql("http://bolao2014.example.com/payment_notifications")
      expect(request.redirect_url).to eql("http://bolao2014.example.com/bet/payment")
      expect(request.abandon_url).to eql("http://bolao2014.example.com/bet/payment")
      expect(request.items.size).to eql(1)
      item = request.items.first
      expect(item.id).to eql(bet.id)
      expect(item.description).to eql("Minha aposta no #{ENV['APP_NAME']}")
      expect(item.amount).to eql(payment.amount.to_f)
    end
    it 'uses an ultrahook host for notifications on development' do
      dev_env = ActiveSupport::StringInquirer.new('development')
      Rails.stub(:env).and_return(dev_env)
      request = described_class.new(payment).gateway_request
      expect(request.notification_url).to eql("http://pagseguro.#{ENV['ULTRAHOOK_USERNAME']}.ultrahook.com/payment_notifications")
    end
  end

  describe '#checkout_code' do
    before(:each) do
      subject.stub(:gateway_response).and_return( double('gateway_response') )
    end
    it 'delegates to the gateway_response code' do
      subject.gateway_response.should_receive(:code).and_return('some-checkout-code')
      expect(subject.checkout_code).to eql('some-checkout-code')
    end
  end

  describe '#checkout_url' do
    before(:each) do
      subject.stub(:gateway_response).and_return( double('gateway_response') )
    end
    it 'delegates to the gateway_response url' do
      subject.gateway_response.should_receive(:url).and_return('http://some.checkout/url')
      expect(subject.checkout_url).to eql('http://some.checkout/url')
    end
  end

  describe '#created_at' do
    before(:each) do
      subject.stub(:gateway_response).and_return( double('gateway_response') )
    end
    let(:some_time) { Time.zone.now }
    it 'delegates to the gateway_response created_at' do
      subject.gateway_response.should_receive(:created_at).and_return(some_time)
      expect(subject.created_at).to eql(some_time)
    end
  end

  describe '#errors' do
    before(:each) do
      subject.stub(:gateway_response).and_return( double('gateway_response') )
    end
    it 'delegates to the gateway_response errors' do
      subject.gateway_response.should_receive(:errors).and_return({some: 'error'})
      expect(subject.errors).to eql({some: 'error'})
    end
  end

  describe '#save' do
    context 'on success', vcr: true do
      it 'returns true, without errors' do
        expect(subject.save).to be_true
        expect(subject.errors).to be_empty
      end
      it 'sends the request to the gateway and exposes the returned attributes' do
        subject.save
        expect(subject.checkout_code).to_not be_blank
        expect(subject.checkout_code).to eql('9D13E4D79F9F9D099494BFB298260DE7') # from VCR
        expect(subject.checkout_url).to_not be_blank
        expect(subject.checkout_url).
          to eql('https://sandbox.pagseguro.uol.com.br/v2/checkout/payment.html?code=9D13E4D79F9F9D099494BFB298260DE7') # from VCR
        expect(subject.created_at).to_not be_nil
        expect(subject.created_at).to eql('2014-05-22 16:34:39 -0300'.to_time) # from VCR
      end
    end
    context 'on failure' do
      before(:each) do
        subject.gateway_request.stub(:register).and_return( double('gateway_response with errors', errors: ['some error']) )
      end
      it 'returns false, with errors' do
        expect(subject.save).to be_false
        expect(subject.errors).to_not be_empty
      end
      it 'does not send the request to the gateway' do
        subject.save
        expect(subject.errors).to eql(['some error'])
        expect(subject.checkout_code).to be_nil
        expect(subject.checkout_url).to be_nil
        expect(subject.created_at).to be_nil
      end
    end
  end

end
