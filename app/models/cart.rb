class Cart
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

  attr_reader :items

  def initialize(items_data = [])
    @items = items_data.map { |item_data| CartItem.new(item_data['product_id'], item_data['quantity']) }
    eager_load_products
  end

  def add_product(added_product)
    item = @items.find { |i| i.product_id == added_product.id }

    if item
      item.quantity += 1
    else
      new_item = CartItem.new(added_product.id)
      new_item.product = added_product
      @items << new_item
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
    @items.map do |item|
      item_data = item.to_h
      item_data['product'] = item.product.as_json
      item_data
    end
  end

  def self.from_session(session_data)
    new(session_data&.dig('items') || [])
  end

  private

  def eager_load_products
    product_ids = @items.map(&:product_id)
    return if product_ids.empty?

    products = Product.where(id: product_ids).index_by(&:id)

    @items.each do |item|
      item.product = products[item.product_id]
    end
  end
end
