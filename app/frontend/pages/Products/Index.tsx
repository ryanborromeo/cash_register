import { Head, Link, router } from '@inertiajs/react'

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
  const handleAddToCart = (productId: number) => {
    router.post('/cart', { product_id: productId }, {
      preserveScroll: true,
    })
  }

  return (
    <>
      <Head title="Products" />

      <div className="container mx-auto p-6">
        <div className="flex justify-between items-center mb-8">
          <h1 className="text-3xl font-bold text-gray-900">
            Cash Register - Products
          </h1>
          <Link href="/cart" className="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition-colors">
            View Cart
          </Link>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {products.map((product) => (
            <div
              key={product.id}
              className="bg-white shadow-lg rounded-lg p-6 border border-gray-200 hover:shadow-xl transition-shadow flex flex-col"
            >
              <div className="flex-grow">
                <div className="text-sm text-gray-500 font-mono mb-2">
                  {product.code}
                </div>
                <h3 className="text-xl font-semibold text-gray-900 mb-3">
                  {product.name}
                </h3>
                <div className="text-2xl font-bold text-green-600 mb-4">
                  ${Number(product.price).toFixed(2)}
                </div>
              </div>
              <button
                onClick={() => handleAddToCart(product.id)}
                className="mt-auto bg-green-500 text-white px-4 py-2 rounded-lg hover:bg-green-600 transition-colors w-full"
              >
                Add to Cart
              </button>
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