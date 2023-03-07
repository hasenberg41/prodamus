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

    context 'main_payment_form' do
      it 'set main_payment_form' do
        expect(described_class).to receive('main_payment_form=').with('ABOBA')
        described_class.main_payment_form = 'ABOBA'
      end
    end
  end
end
