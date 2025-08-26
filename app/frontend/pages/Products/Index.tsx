import { Head, Link, router, usePage } from '@inertiajs/react'

import Alert from '../../components/Alert'

interface Product {
  id: number
  code: string
  name: string
  price: number
}

interface User {
  role: string;
  display_name: string;
}

interface PageProps {
  products: Product[];
  current_user: User | null;
  flash: {
    notice?: string;
    alert?: string;
  };
}

export default function ProductsIndex() {
  const { products, current_user, flash = {} } = usePage().props as unknown as PageProps;

  const handleAddToCart = (productId: number) => {
    router.post('/cart', { product_id: productId }, {
      preserveScroll: true,
    })
  }

  const handleLogout = () => {
    router.delete('/logout')
  }

  const getRoleDescription = (role: string) => {
    switch (role) {
      case 'ceo':
        return 'Buy-one-get-one-free on Green Tea (GR1)';
      case 'coo':
        return 'Bulk discount on Strawberries (SR1) - €4.50 each when buying 3+';
      case 'vp_engineering':
        return 'Coffee discount (CF1) - 2/3 price when buying 3+';
      default:
        return '';
    }
  };

  return (
    <>
      {flash.notice && <Alert key={Date.now()} message={flash.notice} type="notice" />}
      {flash.alert && <Alert key={Date.now()} message={flash.alert} type="alert" />}
      <Head title="Products" />

      <div className="container mx-auto p-6">
        <div className="flex justify-between items-center mb-8">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">
              Cash Register - Products
            </h1>
            {current_user && (
              <div className="mt-2">
                <p className="text-sm text-gray-600">
                  Logged in as <span className="font-medium">{current_user.display_name}</span>
                </p>
                <p className="text-xs text-blue-600">{getRoleDescription(current_user.role)}</p>
              </div>
            )}
          </div>
          <div className="flex space-x-3">
            <Link href="/cart" className="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition-colors">
              View Cart
            </Link>
            {current_user && (
              <button
                onClick={handleLogout}
                className="bg-gray-600 text-white px-4 py-2 rounded-lg hover:bg-gray-700 transition-colors"
              >
                Logout
              </button>
            )}
          </div>
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