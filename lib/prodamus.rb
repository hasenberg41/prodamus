# frozen_string_literal: true

require 'active_support'
require 'active_support/time_with_zone'
require_relative 'verifier'

# Main settings
module Prodamus
  class << self
    attr_accessor :access_token, :main_payment_form, :form_access_duration
    attr_reader :link_expired

    def config
      yield self
    end

    private

    def link_expired=(timezone = 'Moscow')
      tz = ActiveSupport::TimeZone.new(timezone)
      date = tz.now + ENV.fetch('PRODAMUS_ACCESS_DURATION', 1.days).to_i.seconds
      date.strftime('%Y-%m-%d %H:%M')
    end

    def link; end

    def verifier
      @verifier ||= Verifier.new
    end
  end
end
