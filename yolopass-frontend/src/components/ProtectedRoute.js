import React from 'react';
import { Navigate } from 'react-router-dom';

const ProtectedRoute = ({ children }) => {
  const token = localStorage.getItem('token'); // Check for token in localStorage
  
  if (!token) {
    return <Navigate to="/login" />; // Redirect to login if no token found
  }

  return children; // Render children (the protected component) if authenticated
};

export default ProtectedRoute;
