import React from 'react';
import { router } from '@inertiajs/react';

interface Product {
  id: number;
  code: string;
  name: string;
  price: number;
}

interface CartItem {
  product_id: number;
  quantity: number;
  product: Product;
  original_price: number;
  discount: number;
  final_price: number;
}

interface User {
  role: string;
  display_name: string;
}

interface CartSummary {
  items: CartItem[];
  subtotal: number;
  total_discount: number;
  total: number;
}

interface Props {
  cart: CartSummary;
  cart_with_pricing: CartSummary;
  current_user: User | null;
}

const Show: React.FC<Props> = ({ cart, cart_with_pricing, current_user }) => {
  const continueShopping = () => {
    router.get('/products');
  };

  const clearCart = () => {
    router.delete('/cart');
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

  const displayCart = cart_with_pricing || cart;

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white shadow">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-6">
            <div>
              <h1 className="text-3xl font-bold text-gray-900">Shopping Cart</h1>
              {current_user && (
                <p className="text-sm text-gray-600 mt-1">
                  Logged in as <span className="font-medium">{current_user.display_name}</span>
                </p>
              )}
            </div>
            <div className="flex items-center space-x-4">
              <button
                onClick={continueShopping}
                className="bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 rounded-md text-sm font-medium"
              >
                Continue Shopping
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

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {displayCart.items.length === 0 ? (
          <div className="text-center py-12">
            <h3 className="text-lg font-medium text-gray-900 mb-4">Your cart is empty</h3>
            <button
              onClick={continueShopping}
              className="bg-indigo-600 hover:bg-indigo-700 text-white px-6 py-3 rounded-md text-sm font-medium"
            >
              Start Shopping
            </button>
          </div>
        ) : (
          <div className="bg-white shadow overflow-hidden sm:rounded-md">
            <ul className="divide-y divide-gray-200">
              {displayCart.items.map((item, index) => (
                <li key={index} className="px-6 py-4">
                  <div className="flex items-center justify-between">
                    <div className="flex-1">
                      <div className="flex items-center justify-between">
                        <div>
                          <h4 className="text-lg font-medium text-gray-900">
                            {item.product.name}
                          </h4>
                          <p className="text-sm text-gray-500">
                            Code: {item.product.code} | Quantity: {item.quantity}
                          </p>
                        </div>
                        <div className="text-right">
                          {item.discount > 0 ? (
                            <div>
                              <p className="text-sm text-gray-500 line-through">
                                €{item.original_price.toFixed(2)}
                              </p>
                              <p className="text-lg font-bold text-green-600">
                                €{item.final_price.toFixed(2)}
                              </p>
                              <p className="text-xs text-green-600">
                                Saved €{item.discount.toFixed(2)}
                              </p>
                            </div>
                          ) : (
                            <p className="text-lg font-bold text-gray-900">
                              €{item.final_price.toFixed(2)}
                            </p>
                          )}
                        </div>
                      </div>
                    </div>
                  </div>
                </li>
              ))}
            </ul>

            {/* Cart Summary */}
            <div className="bg-gray-50 px-6 py-4">
              <div className="flex justify-between items-center mb-2">
                <span className="text-base font-medium text-gray-900">Subtotal:</span>
                <span className="text-base font-medium text-gray-900">
                  €{displayCart.subtotal.toFixed(2)}
                </span>
              </div>
              {displayCart.total_discount > 0 && (
                <div className="flex justify-between items-center mb-2">
                  <span className="text-base font-medium text-green-600">
                    Total Discount ({current_user?.display_name}):
                  </span>
                  <span className="text-base font-medium text-green-600">
                    -€{displayCart.total_discount.toFixed(2)}
                  </span>
                </div>
              )}
              <div className="border-t border-gray-200 pt-2">
                <div className="flex justify-between items-center">
                  <span className="text-lg font-bold text-gray-900">Total:</span>
                  <span className="text-lg font-bold text-gray-900">
                    €{displayCart.total.toFixed(2)}
                  </span>
                </div>
              </div>
            </div>

            {/* Actions */}
            <div className="bg-white px-6 py-4 flex justify-between">
              <button
                onClick={clearCart}
                className="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-md text-sm font-medium"
              >
                Clear Cart
              </button>
              <button
                onClick={continueShopping}
                className="bg-indigo-600 hover:bg-indigo-700 text-white px-6 py-2 rounded-md text-sm font-medium"
              >
                Continue Shopping
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default Show;
