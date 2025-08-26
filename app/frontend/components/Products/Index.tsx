import React from 'react';
import { router } from '@inertiajs/react';

interface Product {
  id: number;
  code: string;
  name: string;
  price: number;
}

interface User {
  role: string;
  display_name: string;
}

interface CartItem {
  product_id: number;
  quantity: number;
  product: Product;
}

interface Props {
  products: Product[];
  current_user: User | null;
  cart: CartItem[];
}

const Index: React.FC<Props> = ({ products, current_user, cart }) => {
  const addToCart = (productId: number) => {
    router.post('/cart', { product_id: productId });
  };

  const logout = () => {
    router.delete('/logout');
  };

  const viewCart = () => {
    router.get('/cart');
  };

  const getCartItemCount = () => {
    return cart.reduce((total, item) => total + item.quantity, 0);
  };

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
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white shadow">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-6">
            <div>
              <h1 className="text-3xl font-bold text-gray-900">Cash Register</h1>
              {current_user && (
                <p className="text-sm text-gray-600 mt-1">
                  Logged in as <span className="font-medium">{current_user.display_name}</span>
                </p>
              )}
            </div>
            <div className="flex items-center space-x-4">
              {getCartItemCount() > 0 && (
                <button
                  onClick={viewCart}
                  className="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-md text-sm font-medium"
                >
                  View Cart ({getCartItemCount()})
                </button>
              )}
              <button
                onClick={logout}
                className="bg-gray-600 hover:bg-gray-700 text-white px-4 py-2 rounded-md text-sm font-medium"
              >
                Logout
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Role Benefits Banner */}
      {current_user && (
        <div className="bg-blue-50 border-l-4 border-blue-400 p-4 mb-6">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex">
              <div className="flex-shrink-0">
                <svg className="h-5 w-5 text-blue-400" viewBox="0 0 20 20" fill="currentColor">
                  <path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
                </svg>
              </div>
              <div className="ml-3">
                <p className="text-sm text-blue-700">
                  <span className="font-medium">Your benefit:</span> {getRoleDescription(current_user.role)}
                </p>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Products Grid */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {products.map((product) => (
            <div key={product.id} className="bg-white overflow-hidden shadow rounded-lg">
              <div className="p-6">
                <div className="flex items-center justify-between">
                  <div>
                    <h3 className="text-lg font-medium text-gray-900">{product.name}</h3>
                    <p className="text-sm text-gray-500 mt-1">Code: {product.code}</p>
                  </div>
                  <div className="text-right">
                    <p className="text-2xl font-bold text-gray-900">€{product.price}</p>
                  </div>
                </div>
                <div className="mt-6">
                  <button
                    onClick={() => addToCart(product.id)}
                    className="w-full bg-indigo-600 hover:bg-indigo-700 text-white py-2 px-4 rounded-md text-sm font-medium transition-colors duration-200"
                  >
                    Add to Cart
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default Index;
