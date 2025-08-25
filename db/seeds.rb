# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create the three products for the cash register
Product.find_or_create_by!(code: "GR1") do |product|
  product.name = "Green tea"
  product.price = 3.11
end

Product.find_or_create_by!(code: "SR1") do |product|
  product.name = "Strawberries"
  product.price = 5.00
end

Product.find_or_create_by!(code: "CF1") do |product|
  product.name = "Coffee"
  product.price = 11.23
end
