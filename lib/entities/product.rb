# frozen_string_literal: true

require_relative '../prodamus'

module Prodamus
  # Some product to be sent to prodamus
  class Product
    attr_reader :name, :sku, :quantity, :price

    def initialize(name:, price:, quantity: 1, sku: nil)
      @sku = sku.to_s
      @name = name
      @price = price.to_s
      @quantity = quantity.to_s
    end
  end
end
