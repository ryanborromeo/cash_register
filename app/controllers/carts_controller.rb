class CartsController < ApplicationController
  def create
    product = Product.find_by(id: params[:product_id])

    if product
      CartServices::AddProduct.call(current_cart, product)
      save_cart
      flash[:notice] = "#{product.name} added to cart."
    else
      flash[:alert] = 'Product not found.'
    end

    redirect_to root_path
  end

  def show
    render inertia: 'Cart/Show', props: {
      cart: current_cart.detailed_summary
    }
  end

  def destroy
    current_cart.clear
    save_cart
    flash[:notice] = "Cart has been cleared."
    redirect_to cart_path
  end
end
