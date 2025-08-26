import React from 'react';
import { router } from '@inertiajs/react';

interface User {
  role: string;
  display_name: string;
}

interface Props {
  users: User[];
}

const Index: React.FC<Props> = ({ users }) => {
  const handleRoleSelect = (role: string) => {
    router.get(`/login/${role}`);
  };

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
      <div className="sm:mx-auto sm:w-full sm:max-w-md">
        <h2 className="mt-6 text-center text-3xl font-extrabold text-gray-900">
          Cash Register System
        </h2>
        <p className="mt-2 text-center text-sm text-gray-600">
          Select your role to continue
        </p>
      </div>

      <div className="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <div className="bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10">
          <div className="space-y-4">
            {users.map((user) => (
              <button
                key={user.role}
                onClick={() => handleRoleSelect(user.role)}
                className="w-full flex justify-center py-3 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors duration-200"
              >
                Login as {user.display_name}
              </button>
            ))}
          </div>
          
          <div className="mt-8 pt-6 border-t border-gray-200">
            <div className="text-xs text-gray-500 space-y-2">
              <p><strong>CEO:</strong> Gets buy-one-get-one-free on Green Tea (GR1)</p>
              <p><strong>COO:</strong> Gets bulk discount on Strawberries (SR1) - €4.50 each when buying 3+</p>
              <p><strong>VP Engineering:</strong> Gets 2/3 price on Coffee (CF1) when buying 3+</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Index;
