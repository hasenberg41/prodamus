# frozen_string_literal: true

require 'spec_helper'

describe Prodamus do
  it 'provide config options' do
    described_class.config do |c|
      expect(c).to eq described_class
    end
  end

  describe 'parameters' do
    context 'secret_key' do
      it 'set secret_key' do
        expect(described_class).to receive('secret_key=').with('ABOBA')
        described_class.secret_key = 'ABOBA'
      end
    end

    context 'main_payment_form_url' do
      it 'set main_payment_form_url' do
        expect(described_class).to receive('main_payment_form_url=').with('ABOBA')
        described_class.main_payment_form_url = 'ABOBA'
      end
    end
  end

  describe 'link' do
    context 'link_config' do
      it 'provide config options with block' do
        described_class.link_config do |c|
          expect(c).to an_instance_of(Prodamus::LinkConfig)
          c.order_id = '123'
        end

        expect(described_class.link_config).to an_instance_of(Prodamus::LinkConfig)
        expect(described_class.link_config.order_id).to eq '123'
      end

      it 'provide config options on existed' do
        described_class.link_config.order_id = '123'
        described_class.link_config.form_access_duration = 10.days

        expect(described_class.link_config).to an_instance_of(Prodamus::LinkConfig)
        expect(described_class.link_config.order_id).to eq '123'
        expect(described_class.link_config.link_expired).to(match(/\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}/))
      end
    end
  end

  describe 'link' do
    subject { described_class.link }

    before do
      described_class.config do |c|
        c.main_payment_form_url = main_payment_form_url
        c.link_config.add_product(name: 'nger', price: 228_000, quantity: 1, sku: '1223')
      end
    end

    context 'valid configuration' do
      let(:main_payment_form_url) { 'https://testdemo.payform.ru' }

      before { allow_any_instance_of(Prodamus::LinkConfig).to receive(:link_expired).and_return(nil) }

      it 'return link' do
        VCR.use_cassette('link') do
          expect(subject).to match(%r{https://payform.ru/.*})
        end
      end
    end
  end

  describe 'verify' do
    subject { described_class.verify(data, sign) }
    let(:data) do
      {
        date: '2022-12-08T10:42:10+03:00',
        order_id: '8017406',
        order_num: '53',
        domain: 'testdemo.payform.ru',
        sum: '770.00',
        currency: 'rub',
        customer_phone: '+78005553535',
        customer_extra: '',
        payment_type: 'Оплата картой, выпущенной в РФ',
        commission: '100',
        commission_sum: '770.00',
        attempt: '2',
        callbackType: 'json',
        link_expired: '2022-12-08 11:38',
        products: [{ name: 'uuububukaka', price: '770.00', quantity: '1', sum: '770.00' }],
        payment_status: 'success',
        payment_status_description: 'Успешная оплата',
        payment_init: 'manual'
      }
    end

    let(:sign) { Prodamus::Verifier.new(data, 'aboba').encode }

    context 'without secret_key' do
      it 'raise error' do
        expect { subject }.to raise_error RuntimeError, 'Missing secret_key.'
      end
    end

    context 'with secret_key' do
      before { described_class.secret_key = 'aboba' }

      it 'valid verify' do
        expect(subject).to eq true
      end
    end
  end
end
