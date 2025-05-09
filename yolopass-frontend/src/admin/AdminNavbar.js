import React from "react";
import { useNavigate } from "react-router-dom";
import "../styles/AdminStyles.css";

const AdminNavbar = () => {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.removeItem("token");
    navigate("/login");
  };

  return (
    <nav className="admin-navbar">
      <div className="navbar-content">
        <h2>🛡️ YOLOPass Admin</h2>
        <button className="logout-button" onClick={handleLogout}>
          Logout
        </button>
      </div>
    </nav>
  );
};

export default AdminNavbar;
