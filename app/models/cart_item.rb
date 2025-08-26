class CartItem
  attr_reader :product_id
  attr_accessor :quantity, :product

  def initialize(product_id, quantity = 1)
    @product_id = product_id
    @quantity = quantity
  end

  def price
    raise 'Product not loaded' unless product

    product.price * quantity
  end

  def to_h
    { 'product_id' => product_id, 'quantity' => quantity }
  end
end
