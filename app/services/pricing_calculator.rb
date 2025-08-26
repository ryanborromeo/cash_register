class PricingCalculator
  RULES = [
    PricingRules::BuyOneGetOneFreeRule,
    PricingRules::BulkDiscountRule,
    PricingRules::PercentageDiscountRule
  ].freeze

  def self.calculate(cart)
    new(cart).calculate
  end

  def initialize(cart)
    @cart = cart
    @items_breakdown = @cart.items.map do |item|
      {
        item: item,
        original_price: item.price,
        discount: 0,
        final_price: item.price
      }
    end
  end

  def calculate
    apply_discounts
    total_summary
  end

  def calculate_total
    calculate[:total]
  end

  private

  def apply_discounts
    RULES.each do |rule|
      rule.apply!(@items_breakdown)
    end
  end

  def total_summary
    subtotal = @items_breakdown.sum { |b| b[:original_price] }
    total_discount = @items_breakdown.sum { |b| b[:discount] }

    {
      items: @items_breakdown.map { |b| serialize_item(b) },
      subtotal: subtotal.to_d,
      total_discount: total_discount.to_d,
      total: (subtotal - total_discount).to_d
    }
  end

  def serialize_item(breakdown)
    {
      product_id: breakdown[:item].product.id,
      quantity: breakdown[:item].quantity,
      product: breakdown[:item].product,
      original_price: breakdown[:original_price].to_d,
      discount: breakdown[:discount].to_d,
      final_price: breakdown[:final_price].to_d
    }
  end
end
