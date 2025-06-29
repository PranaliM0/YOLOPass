// src/admin/AdminDashboard.js
import React from "react";
import { useNavigate } from "react-router-dom";
import "../styles/AdminDashboard.css";

const AdminDashboard = () => {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.clear();
    navigate("/login");
  };

  return (
    <div className="admin-dashboard">
      <nav className="admin-navbar">
        <h2>Admin Dashboard</h2>
        <button className="logout-btn" onClick={handleLogout}>Logout</button>
      </nav>

      <div className="card-container">
        <div className="admin-card" onClick={() => navigate("/admin/organizers")}>
          <h3>View Organizers</h3>
        </div>
        <div className="admin-card" onClick={() => navigate("/admin/events")}>
          <h3>View Events</h3>
        </div>
        <div className="admin-card" onClick={() => navigate("/admin/users")}>
          <h3>View Users</h3>
        </div>
        
        {/* 🆕 Add this card for Venue Management */}
        <div className="admin-card" onClick={() => navigate("/admin/venues")}>
          <h3>Manage Venues</h3>
        </div>
      </div>
    </div>
  );
};

export default AdminDashboard;
