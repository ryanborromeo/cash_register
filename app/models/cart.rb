class Cart
  attr_reader :items

  def initialize(items_data = [])
    @items = items_data.map { |item_data| CartItem.new(item_data['product_id'], item_data['quantity']) }
    CartServices::EagerLoadProducts.call(self)
  end

  def clear
    @items = []
  end

  def subtotal
    @items.sum(&:price)
  end

  def detailed_summary
    PricingCalculator.calculate(self)
  end

  def to_session
    { 'items' => @items.map(&:to_h) }
  end

  def enriched_items
    @items.map do |item|
      item_data = item.to_h
      item_data['product'] = item.product.as_json
      item_data
    end
  end

  def self.from_session(session_data)
    new(session_data&.dig('items') || [])
  end

end
