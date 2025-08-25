import { Head } from '@inertiajs/react'

interface Product {
  id: number
  code: string
  name: string
  price: number
}

interface Props {
  products: Product[]
}

export default function ProductsIndex({ products }: Props) {
  return (
    <>
      <Head title="Products" />
      
      <div className="container mx-auto p-6">
        <h1 className="text-3xl font-bold text-gray-900 mb-8">
          Cash Register - Products
        </h1>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {products.map((product) => (
            <div
              key={product.id}
              className="bg-white shadow-lg rounded-lg p-6 border border-gray-200 hover:shadow-xl transition-shadow"
            >
              <div className="text-sm text-gray-500 font-mono mb-2">
                {product.code}
              </div>
              <h3 className="text-xl font-semibold text-gray-900 mb-3">
                {product.name}
              </h3>
              <div className="text-2xl font-bold text-green-600">
                ${product.price.toFixed(2)}
              </div>
            </div>
          ))}
        </div>
        
        {products.length === 0 && (
          <div className="text-center text-gray-500 mt-8">
            <p>No products available.</p>
          </div>
        )}
      </div>
    </>
  )
}