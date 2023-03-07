# frozen_string_literal: true

require_relative 'services/verifier'
require_relative 'services/link'

# Main settings
module Prodamus
  class << self
    attr_accessor :secret_key, :main_payment_form

    def config
      yield self if block_given?
    end

    private

    def link; end

    def verifier
      @verifier ||= Verifier.new
    end
  end
end
