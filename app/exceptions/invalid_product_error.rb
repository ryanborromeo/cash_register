class InvalidProductError < ApplicationError
  def initialize(message = 'Invalid product data')
    super
  end
end
