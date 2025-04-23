import React from 'react';
import { useNavigate } from 'react-router-dom';
import '../styles/OrganizerDashboard.css';

const OrganizerDashboard = () => {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('role'); // if stored
    navigate('/login');
  };

  const goToCreateEvent = () => {
    navigate('/organizer/create-event');
  };

  const goToEventList = () => {
    navigate('/organizer/events');
  };

  const goToProfile = () => {
    navigate('/organizer/profile');
  };

  return (
    <div className="dashboard-container">
      <div className="dashboard-header">
        <h2>Organizer Dashboard</h2>
        <button className="logout-btn" onClick={handleLogout}>Logout</button>
      </div>

      <div className="dashboard-options">
        <div className="dashboard-card" onClick={goToCreateEvent}>
          <h3>Create Event</h3>
          <p>Plan and publish a new event.</p>
        </div>

        <div className="dashboard-card" onClick={goToEventList}>
          <h3>View Events</h3>
          <p>Manage all your active and closed events.</p>
        </div>

        <div className="dashboard-card" onClick={goToProfile}>
          <h3>My Profile</h3>
          <p>Update your account info.</p>
        </div>

        {/* Future: Add analytics, CSV download, feedback view */}
      </div>
    </div>
  );
};

export default OrganizerDashboard;
