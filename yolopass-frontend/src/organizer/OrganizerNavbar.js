import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import '../styles/OrganizerNavbar.css';

const OrganizerNavbar = () => {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('role'); // if stored
    navigate('/login');
  };

  return (
    <nav className="navbar">
      <div className="navbar-container">
        <div className="navbar-logo">
          <Link to="/organizer/dashboard">YOLOPass</Link>
        </div>

        <div className="navbar-links">
          <ul>
            <li><Link to="/organizer/dashboard">Dashboard</Link></li>
            <li><Link to="/organizer/events">Events</Link></li>
            <li><Link to="/organizer/profile">Profile</Link></li>
          </ul>
        </div>

        <div className="navbar-logout">
          <button onClick={handleLogout} className="logout-btn">Logout</button>
        </div>
      </div>
    </nav>
  );
};

export default OrganizerNavbar;
