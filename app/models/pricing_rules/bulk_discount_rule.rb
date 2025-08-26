class PricingRules::BulkDiscountRule < PricingRule
  PRODUCT_CODE = 'SR1'.freeze
  MIN_QUANTITY = 3
  NEW_PRICE = 4.50

  def self.apply!(breakdown)
    item_breakdown = breakdown.find { |b| b[:item].product.code == PRODUCT_CODE }

    return unless item_breakdown && item_breakdown[:item].quantity >= MIN_QUANTITY

    item = item_breakdown[:item]
    discount = (item.product.price - NEW_PRICE) * item.quantity

    item_breakdown[:discount] += discount
    item_breakdown[:final_price] -= discount
  end
end
