# frozen_string_literal: true

require 'active_support'
require 'active_support/time_with_zone'
require_relative '../prodamus'

# Main settings
module Prodamus
  # Configure request wich be sent for get purchase link
  class Link
    # rubocop:disable Naming/MethodName
    attr_accessor :order_id, :sys, :customer_phone, :customer_email,
                  :customer_extra, :payment_method,
                  :urlReturn, :urlSuccess, :urlNotification,
                  :installments_disabled, :currency, :payments_limit
    # rubocop:enable Naming/MethodName

    attr_writer :form_access_duration, :timezone
    attr_reader :products, :available_payment_methods

    def products=(name:, price:, quantity:, sku: nil)
      @products << Product.new(name, price, quantity, sku)
    end

    def initialize
      yield self if block_given?
    end

    def link_expired
      tz = ActiveSupport::TimeZone.new(timezone)
      date = tz.now + form_access_duration.to_i.seconds
      date.strftime('%Y-%m-%d %H:%M')
    end

    # rubocop:disable Metrics/MethodLength
    def format_result
      {
        'do' => 'link',
        'callbackType' => 'json',
        'sys' => @sys,
        'order_id' => @order_id,
        'customer_phone' => @customer_phone,
        'customer_email' => @customer_email,
        'customer_extra' => @customer_extra,
        'payment_method' => @payment_method,
        'available_payment_methods' => @available_payment_methods,
        'urlReturn' => @urlReturn,
        'link_expired' => link_expired,
        'products[0][name]' => object.title,
        'products[0][sku]' => object.id.to_s,
        'products[0][price]' => object.price.to_s,
        'products[0][quantity]' => '1'
      }
    end
    # rubocop:enable Metrics/MethodLength

    def available_payment_methods=(*payment_methods); end

    def form_access_duration
      @form_access_duration || 1.day
    end

    def timezone
      @timezone || 'Moscow'
    end
  end
end
