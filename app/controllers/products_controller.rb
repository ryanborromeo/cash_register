class ProductsController < ApplicationController
  def index
    @products = Product.all.order(:code)
    render inertia: 'Products/Index', props: {
      products: @products.as_json(only: [:id, :code, :name, :price])
    }
  end
end