module CartServices
  class AddProduct
    def self.call(cart, product)
      item = cart.items.find { |i| i.product_id == product.id }

      if item
        item.quantity += 1
      else
        new_item = Cart::CartItem.new(product.id)
        new_item.product = product
        cart.items << new_item
      end

      cart
    end
  end
end