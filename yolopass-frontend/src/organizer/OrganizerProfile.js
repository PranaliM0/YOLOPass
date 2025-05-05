import React, { useEffect, useState } from 'react';
import axios from 'axios';
import '../styles/OrganizerProfile.css';
import { useNavigate } from 'react-router-dom';

const OrganizerProfile = () => {
  const [organizer, setOrganizer] = useState(null);
  const [eventSummary, setEventSummary] = useState({});
  const navigate = useNavigate();

  useEffect(() => {
    fetchOrganizerProfile();
  }, []);

  const fetchOrganizerProfile = async () => {
    try {
      const token = localStorage.getItem('token');
      const response = await axios.get('http://localhost:3001/organizer/profile', {
        headers: { Authorization: `Bearer ${token}` }
      });

      // Check if the response is valid
      if (response.data && response.data.organizer) {
        setOrganizer(response.data.organizer);
        setEventSummary(response.data.summary); // Ensure this structure matches the backend response
      } else {
        console.error('Invalid response format');
      }
    } catch (error) {
      console.error('Error fetching organizer profile:', error);
    }
  };

  const handleLogout = () => {
    localStorage.clear();
    navigate('/login');
  };

  const handleEditProfile = () => {
    navigate('/organizer/edit-profile');
  };

  return (
    <div className="organizer-profile-container">
      <div className="logout-button" onClick={handleLogout}>Logout</div>

      <h2>Organizer Profile</h2>
      {organizer ? (
        <div className="profile-card">
          <div className="profile-left">
            <img
              src="/default-profile.png"
              alt="Profile"
              className="profile-image"
            />
            <h3>{organizer.name}</h3>
            <p><strong>Email:</strong> {organizer.email}</p>
            <p><strong>Role:</strong> Organizer</p>
            <button onClick={handleEditProfile}>Edit Profile</button>
          </div>

          <div className="profile-right">
            <h4>Event Summary</h4>
            <p><strong>Total Events:</strong> {eventSummary.total || 0}</p>
            <p><strong>Open Events:</strong> {eventSummary.open || 0}</p>
            <p><strong>Closed Events:</strong> {eventSummary.closed || 0}</p>
            <p><strong>Participants:</strong> {eventSummary.participants || 0}</p>
            <button onClick={() => navigate('/organizer/change-password')}>Change Password</button>
          </div>
        </div>
      ) : (
        <p>Loading profile...</p>
      )}
    </div>
  );
};

export default OrganizerProfile;
