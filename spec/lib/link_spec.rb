# frozen_string_literal: true

require 'spec_helper'

describe Prodamus::Link do
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

  describe 'available_payment_methods' do
    subject { described_class.new }

    it ''
  end
end
