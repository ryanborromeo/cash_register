import { Head, Link } from '@inertiajs/react';
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
}

interface CartProps {
  cart: {
    items: CartItem[];
    total: number;
  };
}

const CartShow: React.FC<CartProps> = ({ cart }) => {
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
            <div className="grid grid-cols-4 gap-4 font-bold border-b pb-4 mb-4 text-gray-600">
              <div>Product</div>
              <div className="text-right">Price</div>
              <div className="text-center">Quantity</div>
              <div className="text-right">Total</div>
            </div>
            {cart.items.map(item => (
              <div key={item.product_id} className="grid grid-cols-4 gap-4 border-b py-4 items-center">
                <div>{item.product.name}</div>
                <div className="text-right">${Number(item.product.price).toFixed(2)}</div>
                <div className="text-center">{item.quantity}</div>
                <div className="text-right font-medium">${(Number(item.product.price) * item.quantity).toFixed(2)}</div>
              </div>
            ))}
            <div className="grid grid-cols-4 gap-4 font-bold mt-6 text-xl">
              <div className="col-span-3 text-right">Grand Total:</div>
              <div className="text-right">${Number(cart.total).toFixed(2)}</div>
            </div>
          </div>
        )}
      </div>
    </>
  );
};

export default CartShow;

