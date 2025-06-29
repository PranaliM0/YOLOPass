// src/admin/AdminNavbar.js
import React from 'react';
import { Link } from 'react-router-dom';
import '../styles/AdminStyles.css';

const AdminNavbar = () => {
  const handleLogout = () => {
    localStorage.removeItem('token');
    window.location.href = '/login'; // Redirect to login
  };

  return (
    <nav className="admin-navbar">
      <ul>
        <li>
          <Link to="/admin/dashboard">Dashboard</Link>
        </li>
        <li>
          <Link to="/admin/organizers">Organizers</Link>
        </li>
        <li>
          <Link to="/admin/events">Events</Link>
        </li>
        <li>
          <button onClick={handleLogout} className="logout-btn">Logout</button>
        </li>
      </ul>
    </nav>
  );
};

export default AdminNavbar;
