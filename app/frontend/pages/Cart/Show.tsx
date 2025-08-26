import { Head, Link, router } from '@inertiajs/react';
import React from 'react';

interface Product {
  id: number;
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

interface CartProps {
  cart: CartSummary;
  cart_with_pricing: CartSummary;
  current_user: User | null;
}

const CartShow: React.FC<CartProps> = ({ cart, cart_with_pricing, current_user }) => {
  const handleClearCart = () => {
    if (confirm('Are you sure you want to clear your cart?')) {
      router.delete('/cart');
    }
  };

  const handleLogout = () => {
    router.delete('/logout');
  };


  // Use cart_with_pricing if available (has role-based discounts), otherwise fallback to cart
  const displayCart = cart_with_pricing || cart;

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
      <Head title="Your Cart" />
      <div className="container mx-auto p-6">
        <div className="flex justify-between items-center mb-8">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Your Cart</h1>
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
            <Link href="/products" className="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition-colors">
              &larr; Back to Products
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

        {displayCart.items.length === 0 ? (
          <div className="text-center text-gray-500 mt-8">
            <p>Your cart is empty.</p>
          </div>
        ) : (
          <div className="bg-white shadow-lg rounded-lg p-6 border border-gray-200">
            <div className="grid grid-cols-5 gap-4 font-bold border-b pb-4 mb-4 text-gray-600">
              <div>Product</div>
              <div className="text-center">Qty</div>
              <div className="text-right">Price</div>
              <div className="text-right">Discount</div>
              <div className="text-right">Total</div>
            </div>
            {displayCart.items.map(item => (
              <div key={item.product_id} className="grid grid-cols-5 gap-4 border-b py-4 items-center">
                <div>{item.product.name}</div>
                <div className="text-center">{item.quantity}</div>
                <div className="text-right">
                  {item.discount > 0 ? (
                    <span className="text-gray-500 line-through">€{Number(item.original_price).toFixed(2)}</span>
                  ) : (
                    <span>€{Number(item.original_price).toFixed(2)}</span>
                  )}
                </div>
                <div className="text-right text-red-500">
                  {item.discount > 0 ? `-€${Number(item.discount).toFixed(2)}` : '€0.00'}
                </div>
                <div className="text-right font-medium">€{Number(item.final_price).toFixed(2)}</div>
              </div>
            ))}
            <div className="mt-6 text-right space-y-2">
              <div className="text-lg">
                <span className="font-medium text-gray-600">Subtotal: </span>
                <span className="font-bold">€{Number(displayCart.subtotal).toFixed(2)}</span>
              </div>
              {displayCart.total_discount > 0 && (
                <div className="text-lg">
                  <span className="font-medium text-gray-600">Total Savings ({current_user?.display_name}): </span>
                  <span className="font-bold text-red-500">-€{Number(displayCart.total_discount).toFixed(2)}</span>
                </div>
              )}
              <div className="text-2xl font-bold border-t pt-2 mt-2">
                <span className="font-medium text-gray-900">Grand Total: </span>
                <span>€{Number(displayCart.total).toFixed(2)}</span>
              </div>
            </div>

            <div className="mt-8 flex justify-end">
              <button
                onClick={handleClearCart}
                className="bg-red-500 text-white px-6 py-2 rounded-lg hover:bg-red-600 transition-colors shadow-md"
              >
                Clear Cart
              </button>
            </div>
          </div>
        )}
      </div>
    </>
  );
};

export default CartShow;

