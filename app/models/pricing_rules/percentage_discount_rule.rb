class PricingRules::PercentageDiscountRule < PricingRule
  PRODUCT_CODE = 'CF1'.freeze
  MIN_QUANTITY = 3
  DISCOUNT_FACTOR = 1.0 / 3.0

  def self.apply!(breakdown)
    item_breakdown = breakdown.find { |b| b[:item].product.code == PRODUCT_CODE }

    return unless item_breakdown && item_breakdown[:item].quantity >= MIN_QUANTITY

    discount = (item_breakdown[:original_price] * DISCOUNT_FACTOR).round(2)

    item_breakdown[:discount] += discount
    item_breakdown[:final_price] -= discount
  end
end
