class PricingRules::BuyOneGetOneFreeRule < PricingRule
  PRODUCT_CODE = 'GR1'.freeze

  def self.apply!(breakdown)
    item_breakdown = breakdown.find { |b| b[:item].product && b[:item].product.code == PRODUCT_CODE }

    return unless item_breakdown

    item = item_breakdown[:item]
    discount = (item.quantity / 2) * item.product.price

    item_breakdown[:discount] += discount
    item_breakdown[:final_price] -= discount
  end
end
