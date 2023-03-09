# frozen_string_literal: true

require 'spec_helper'

describe Prodamus::LinkConfig do
  it 'provide config options' do
    described_class.new do |c|
      expect(c).to an_instance_of(described_class)
    end
  end

  describe 'parameters' do
    context 'order_id' do
      it 'set order_id' do
        expect_any_instance_of(described_class).to receive('order_id=').with(228)
        described_class.new.order_id = 228
      end
    end
  end

  describe 'link_expired' do
    subject { described_class.new.link_expired }

    it 'return valid datetime string' do
      expect(subject).to(match(/\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}/))
    end
  end

  describe 'add_available_payment_methods' do
    let(:tantum_verde_forte) { described_class.new }
    subject { tantum_verde_forte.add_available_payment_methods(methods) }

    context 'one method' do
      let(:methods) { 'ACkztjp' }

      it 'add method' do
        subject
        expect(tantum_verde_forte.available_payment_methods).to eq [methods]
      end
    end

    context 'many methods' do
      let(:methods) { %w[ACkztjp ACf ACeuruk ACusduk ACEURNMBX] }

      it 'add method' do
        subject
        expect(tantum_verde_forte.available_payment_methods).to eq methods
      end
    end

    context 'not avaible methods' do
      let(:methods) { %w[ACkztjp ACf ACeuruk ACusduk ABOBA] }

      it 'add method' do
        expect { subject }.to raise_error(ArgumentError, 'Not avaible payment methods.')
      end
    end

    context 'installments disabled' do
      let(:methods) { %w[installment_10_28 installment_12_28 installment_0_0_3] }
      before { tantum_verde_forte.installments_disabled = true }

      it 'add method' do
        expect do
          subject
        end.to raise_error(ArgumentError, 'Installments payment methods is not avaible when installments disabled.')
      end
    end
  end

  describe 'format_result' do
    let(:tantum_verde_forte) { described_class.new }
    subject { tantum_verde_forte.format_result }

    context 'without products' do
      it 'raise error' do
        expect { subject }.to raise_error(RuntimeError, 'Product must be exists')
      end
    end

    context 'valid result' do
      before { tantum_verde_forte.add_product(name: 'lube', price: 100, quantity: 1, sku: 1) }

      it 'return valid payload' do
        expect(subject).to eq({
                                'do' => 'link',
                                'callbackType' => 'json',
                                'available_payment_methods' => 'AC|ACkz|ACkztjp|ACf|ACeuruk|ACusduk|' \
                                                               'ACEURNMBX|ACUSDNMBX|SBP|PC|QW|GP|sbol|invoice',
                                'installments_disabled' => '1',
                                'payments_limit' => '1',
                                'link_expired' => tantum_verde_forte.link_expired,
                                'products[0][name]' => 'lube',
                                'products[0][price]' => '100',
                                'products[0][quantity]' => '1',
                                'products[0][sku]' => '1'
                              })
      end
    end
  end
end
