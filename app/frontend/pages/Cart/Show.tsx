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

interface CartProps {
  cart: {
    items: CartItem[];
    subtotal: number;
    total_discount: number;
    total: number;
  };
}

const CartShow: React.FC<CartProps> = ({ cart }) => {
  const handleClearCart = () => {
    if (confirm('Are you sure you want to clear your cart?')) {
      router.delete('/cart');
    }
  };

  return (
    <>
      <Head title="Your Cart" />
      <div className="container mx-auto p-6">
        <div className="flex justify-between items-center mb-8">
          <h1 className="text-3xl font-bold text-gray-900">Your Cart</h1>
          <Link href="/" className="text-blue-500 hover:underline">
            &larr; Back to Products
          </Link>
        </div>

        {cart.items.length === 0 ? (
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
            {cart.items.map(item => (
              <div key={item.product_id} className="grid grid-cols-5 gap-4 border-b py-4 items-center">
                <div>{item.product.name}</div>
                <div className="text-center">{item.quantity}</div>
                <div className="text-right text-gray-500 line-through">${Number(item.original_price).toFixed(2)}</div>
                <div className="text-right text-red-500">-${Number(item.discount).toFixed(2)}</div>
                <div className="text-right font-medium">${Number(item.final_price).toFixed(2)}</div>
              </div>
            ))}
            <div className="mt-6 text-right space-y-2">
              <div className="text-lg">
                <span className="font-medium text-gray-600">Subtotal: </span>
                <span className="font-bold">${Number(cart.subtotal).toFixed(2)}</span>
              </div>
              <div className="text-lg">
                <span className="font-medium text-gray-600">Total Savings: </span>
                <span className="font-bold text-red-500">-${Number(cart.total_discount).toFixed(2)}</span>
              </div>
              <div className="text-2xl font-bold border-t pt-2 mt-2">
                <span className="font-medium text-gray-900">Grand Total: </span>
                <span>${Number(cart.total).toFixed(2)}</span>
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

