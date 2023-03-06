# frozen_string_literal: true

require 'spec_helper'

describe Prodamus::Verifier do
  let(:verifier) { described_class.new(data, key) }

  it 'created' do
    obj = described_class.new('dawn', 'gavrik')
    expect(obj.class).to eq described_class
    expect(obj.data).to eq 'dawn'
    expect(obj.key).to eq 'gavrik'
    expect(obj.algorithm).to eq 'sha256'
  end

  describe 'encode' do
  end
end
