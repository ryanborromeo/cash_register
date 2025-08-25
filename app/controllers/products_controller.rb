class ProductsController < ApplicationController
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
      end
    }
  rescue ActiveRecord::ConnectionNotEstablished => e
    render inertia: "Errors/DatabaseError", props: { message: "Database unavailable" }
  rescue StandardError => e
    Rails.logger.error "Error loading products: #{e.message}"
    render inertia: "Errors/ServerError", props: { message: "Unable to load products" }
  end
end
