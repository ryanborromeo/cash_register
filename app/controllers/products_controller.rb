class ProductsController < ApplicationController
  before_action :require_user_role

  def index
    @products = Product.by_code
    render inertia: "Products/Index", props: {
      products: @products.map do |p|
        {
          id: p.id,
          code: p.code,
          name: p.name,
          price: p.price.to_d
        }
      end,
      current_user: current_user ? {
        role: current_user.role,
        display_name: current_user.display_name
      } : nil,
      cart: current_cart.enriched_items
    }
  end
end
