class ProductNotFoundError < ApplicationError
  def initialize(message = 'Product not found')
    super
  end
end
