class ProductsController < ApplicationController
  def index
    @products = Product.all.order(:code)
    render inertia: 'Products/Index', props: {
      products: @products.map do |p|
        {
          id: p.id,
          code: p.code,
          name: p.name,
          price: p.price.to_f
        }
      end
    }
  end
end