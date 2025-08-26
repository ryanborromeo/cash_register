module CartServices
  class AddProduct
    def self.call(cart, product)
      item = cart.items.find { |i| i.product_id == product.id }

      if item
        item.quantity += 1
      else
        new_item = CartItem.new(product.id)
        new_item.product = product
        cart.items << new_item
      end

      cart
    end
  end

  class EagerLoadProducts
    def self.call(cart)
      product_ids = cart.items.map(&:product_id)
      return if product_ids.empty?

      products = Product.where(id: product_ids).index_by(&:id)

      cart.items.each do |item|
        item.product = products[item.product_id]
      end
    end
  end
end