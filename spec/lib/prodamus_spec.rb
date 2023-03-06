# frozen_string_literal: true

require 'spec_helper'

describe Prodamus do
  it 'provide config options' do
    described_class.config do |c|
      expect(c).to eq described_class
    end
  end

  describe 'parameters' do
    context 'access_token' do
      it 'set access_token' do
        expect(described_class).to receive('access_token=').with('ABOBA')
        described_class.access_token = 'ABOBA'
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
