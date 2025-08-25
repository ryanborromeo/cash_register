import React from 'react';

interface ErrorPageProps {
  status: number;
  message: string;
}

const ErrorPage: React.FC<ErrorPageProps> = ({ status, message }) => {
  const title = {
    500: 'Server Error',
    404: 'Page Not Found',
    403: 'Forbidden',
  }[status] || 'Error';

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100">
      <div className="text-center">
        <h1 className="text-6xl font-bold text-gray-800">{status}</h1>
        <h2 className="mt-4 text-2xl font-semibold text-gray-600">{title}</h2>
        <p className="mt-2 text-gray-500">{message}</p>
        <a href="/" className="mt-6 inline-block px-6 py-3 text-sm font-semibold text-white bg-blue-500 rounded-md hover:bg-blue-600">
          Go Home
        </a>
      </div>
    </div>
  );
};

export default ErrorPage;
