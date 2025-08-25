class Cart
  class CartItem
    attr_reader :product_id
    attr_accessor :quantity

    def initialize(product_id, quantity = 1)
      @product_id = product_id
      @quantity = quantity
    end

    def product
      Product.find(product_id)
    end

    def price
      product.price * quantity
    end

    def to_h
      { 'product_id' => product_id, 'quantity' => quantity }
    end
  end

  attr_reader :items

  def initialize(items_data = [])
    @items = items_data.map { |item_data| CartItem.new(item_data['product_id'], item_data['quantity']) }
  end

  def add_product(product)
    item = @items.find { |i| i.product_id == product.id }

    if item
      item.quantity += 1
    else
      @items << CartItem.new(product.id)
    end
  end

  def clear
    @items = []
  end

  def total
    @items.sum(&:price)
  end

  def to_session
    { 'items' => @items.map(&:to_h) }
  end

  def enriched_items
    product_ids = @items.map(&:product_id)
    products = Product.where(id: product_ids).index_by(&:id)

    @items.map do |item|
      product = products[item.product_id]
      item_data = item.to_h
      item_data['product'] = product.as_json if product
      item_data
    end
  end

  def self.from_session(session_data)
    new(session_data&.dig('items') || [])
  end
end
