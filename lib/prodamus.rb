# frozen_string_literal: true

require 'faraday'
require_relative 'helper'
require_relative 'entities/product'
require_relative 'services/verifier'
require_relative 'services/link_config'

# Main settings
module Prodamus
  class << self
    # payment form provided by prodamus
    attr_accessor :main_payment_form_url

    # key from main form settings
    attr_accessor :secret_key

    def config
      yield self if block_given?
    end

    # verify signatured data
    def verify(data, sign)
      verifier(data).verify(sign)
    end

    # get link to payment form
    def link
      response = Faraday.new(
        url: @main_payment_form_url,
        params: @link_config.format_result,
        headers: { 'Content-Type' => 'text/plain', 'charset' => 'utf-8' },
        request: { timeout: 5 }
      ).get

      raise response.body.force_encoding('utf-8') if response.status != 200

      response.body
    end

    # configure the payload to receive the payment form
    def link_config(&block)
      @link_config = LinkConfig.new(&block)
    end

    def verifier(data, algorithm = 'sha256')
      raise 'Missing secret_key.' if @secret_key.nil?

      @verifier = Verifier.new(data, @secret_key, algorithm)
    end
  end
end
