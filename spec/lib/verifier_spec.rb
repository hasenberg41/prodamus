# frozen_string_literal: true

require 'spec_helper'

describe Prodamus::Verifier do
  let(:verifier) { described_class.new(data, key) }
  let(:data) { { b: [{ l: 's', a: 123, r: 'sd' }], f: 'F', a: 228 } }
  let(:key) { 'velikiy sup navaril' }

  it 'created' do
    obj = described_class.new('dawn', 'gavrik')
    expect(obj.class).to eq described_class
    expect(obj.data).to eq 'dawn'
    expect(obj.key).to eq 'gavrik'
    expect(obj.algorithm).to eq 'sha256'
  end

  describe 'encode' do
    subject { verifier.encode }

    it 'should encode' do
      expect(subject.class).to eq String
    end

    context 'invalid data' do
      let(:data) { 'kukaracha' }

      it 'raise error' do
        expect { subject }.to raise_error(ArgumentError, 'Expected a Hash with array of hashes.')
      end
    end
  end

  describe 'verify' do
    subject { verifier.verify(sign) }
    let(:sign) { verifier.encode }

    it 'should return true' do
      expect(subject).to eq true
    end

    context 'amogus signature' do
      subject { verifier.verify(sign) }
      let(:sign) { described_class.new(data, 'AMOGUS').encode }

      it 'should return true' do
        expect(subject).to eq false
      end
    end
  end
end
