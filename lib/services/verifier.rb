# frozen_string_literal: true

require_relative '../prodamus'

module Prodamus
  # HMAC encoding and verify signature
  class Verifier
    attr_accessor :data, :key, :algorithm

    def initialize(data, key, algorithm = 'sha256')
      @data = data
      @key = key
      @algorithm = algorithm
    end

    def verify(sign)
      encoded_data = encode
      encoded_data && (encoded_data == sign)
    end

    def encode
      data = sort(@data).to_json
      digest = OpenSSL::Digest.new(@algorithm)

      OpenSSL::HMAC.hexdigest(digest, @key, data)
    rescue NoMethodError
      raise ArgumentError, 'Expected a Hash with array of hashes.'
    end

    private

    def sort(data)
      data.sort.to_h.transform_values do |value|
        value.is_a?(Array) ? value.map { |product| product.sort.to_h.transform_values(&:to_s) } : value.to_s
      end
    end
  end
end
