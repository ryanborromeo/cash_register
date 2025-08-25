class CartsController < ApplicationController
  def create
    product = Product.find(params[:product_id])
    current_cart.add_product(product)
    save_cart

    redirect_to root_path, notice: "Product added to cart"
  end

  def show
    render inertia: 'Cart/Show', props: {
      cart: {
        items: current_cart.enriched_items,
        total: current_cart.total
      }
    }
  end
end
