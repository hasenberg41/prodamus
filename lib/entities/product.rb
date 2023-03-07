# frozen_string_literal: true

require_relative '../prodamus'

module Prodamus
  # Some product to be sent to prodamus
  class Product
    def initialize(name:, price:, quantity:, sku: nil)
      @sku = sku
      @name = name
      @price = price
      @quantity = quantity
    end
  end
end
