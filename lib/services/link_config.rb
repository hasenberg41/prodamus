# frozen_string_literal: true

require 'active_support'
require 'active_support/time_with_zone'
require_relative '../prodamus'

# Main settings
module Prodamus
  # Configure request wich be sent for get purchase link
  class LinkConfig
    DEFAULT_PAYMENTS_LIMIT = 1

    # rubocop:disable Naming/MethodName
    attr_accessor :order_id, :sys, :customer_phone, :customer_email,
                  :customer_extra, :payment_method,
                  :urlReturn, :urlSuccess, :urlNotification,
                  :currency, :payments_limit
    # rubocop:enable Naming/MethodName

    attr_writer :form_access_duration, :timezone
    attr_reader :products, :available_payment_methods

    def initialize
      @products = []
      yield self if block_given?
    end

    # Transform payload to be sent
    # rubocop:disable Metrics/MethodLength
    def format_result
      raise 'Product must be exists' if @products.empty?

      result = {
        'do' => 'link',
        'callbackType' => 'json',
        'sys' => @sys,
        'order_id' => @order_id,
        'customer_phone' => @customer_phone,
        'customer_email' => @customer_email,
        'customer_extra' => @customer_extra,
        'payment_method' => @payment_method,
        'available_payment_methods' => (@available_payment_methods || NON_INSTALLMENTS_PAYMENT_METHODS).join('|'),
        'urlReturn' => @urlReturn,
        'urlSuccess' => @urlSuccess,
        'urlNotification' => @urlNotification,
        'installments_disabled' => (@installments_disabled || 1).to_s,
        'currency' => @currency,
        'payments_limit' => (@payments_limit || DEFAULT_PAYMENTS_LIMIT).to_s,
        'link_expired' => link_expired
      }.compact!

      @products.each_with_index do |product, index|
        result.merge!({
                        "products[#{index}][name]" => product.name,
                        "products[#{index}][sku]" => product.sku,
                        "products[#{index}][price]" => product.price,
                        "products[#{index}][quantity]" => product.quantity
                      })
      end

      result
    end
    # rubocop:enable Metrics/MethodLength

    def add_product(name:, price:, quantity: 1, sku: nil)
      @products << Product.new(name: name, price: price, quantity: quantity, sku: sku)
    end

    def add_available_payment_methods(*payment_methods)
      payment_methods.flatten!

      raise 'payment_method is already defined' if @payment
      raise ArgumentError, 'Not avaible payment methods.' unless (payment_methods - ALL_AVAIBLE_PAYMENT_METHODS).empty?

      if @installments_disabled&.positive? && !(payment_methods - NON_INSTALLMENTS_PAYMENT_METHODS).empty?
        raise ArgumentError, 'Installments payment methods is not avaible when installments disabled.'
      end

      @available_payment_methods = [] if @available_payment_methods.nil?
      @available_payment_methods += payment_methods
    end

    def installments_disabled=(disabled)
      @installments_disabled = disabled ? 1 : 0
    end

    def installments_disabled
      !@installments_disabled.zero?
    end

    def link_expired
      tz = ActiveSupport::TimeZone.new(timezone)
      date = tz.now + form_access_duration.to_i.seconds
      date.strftime('%Y-%m-%d %H:%M')
    end

    def form_access_duration
      @form_access_duration || 1.day
    end

    def timezone
      @timezone || 'Moscow'
    end
  end
end
