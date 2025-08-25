import React, { useEffect, useState } from 'react';

interface AlertProps {
  message: string;
  type: 'notice' | 'alert';
}

const Alert: React.FC<AlertProps> = ({ message, type }) => {
  const [visible, setVisible] = useState(true);

  useEffect(() => {
    const timer = setTimeout(() => {
      setVisible(false);
    }, 3000);

    return () => clearTimeout(timer);
  }, []);

  if (!visible) {
    return null;
  }

  const baseClasses = 'fixed top-5 right-5 p-4 rounded-lg shadow-lg text-white transition-opacity duration-300 z-50';
  const typeClasses = {
    notice: 'bg-green-500',
    alert: 'bg-red-500',
  };

  return (
    <div className={`${baseClasses} ${typeClasses[type]}`}>
      <span>{message}</span>
      <button onClick={() => setVisible(false)} className="ml-4 font-bold text-white hover:text-gray-200">
        &times;
      </button>
    </div>
  );
};

export default Alert;
