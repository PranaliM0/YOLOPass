import React, { useState, useEffect } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import "../styles/AttendeeProfile.css";

const AttendeeProfile = () => {
  const [profile, setProfile] = useState(null);
  const [registeredEvents, setRegisteredEvents] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  // Fetch Profile Information
  const fetchProfileData = async () => {
    try {
      const token = localStorage.getItem("token");
      const res = await axios.get("http://localhost:3001/attendee/profile", {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      console.log("API Response:", res.data);  // Log the response
      setProfile(res.data.profile);
      setRegisteredEvents(res.data.registered_events);
      setLoading(false);
    } catch (error) {
      console.error("Error fetching profile data:", error);
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchProfileData();
  }, []);

  if (loading) {
    return <div>Loading...</div>;
  }

  const handleEventRegistrationClick = (registrationId) => {
    navigate(`/attendee/review/${registrationId}`);
  };

  return (
    <div className="profile-container">
      <div className="profile-header">
        <h1>{profile?.name}'s Profile</h1>
        <div className="profile-meta">
          <div>Email: {profile?.email}</div>
        </div>
      </div>

      <div className="profile-stats">
        <h2>My Event Registrations</h2>
        <div className="stats-item">
          <div>Registered Events:</div>
          <div>{registeredEvents.length}</div>
        </div>
      </div>

      <div className="event-list">
        <h3>Upcoming Events</h3>
        {registeredEvents.length > 0 ? (
          <ul>
            {registeredEvents.map((event) => (
              <li
                key={event.registration_id}
                className="event-item"
                onClick={() => handleEventRegistrationClick(event.registration_id)}
              >
                <div className="event-item-title">{event.event_name}</div>
                <div className="event-item-details">
                  <span>{event.event_venue}</span> | <span>{event.event_start_time?.slice(0, 10)}</span>
                </div>
              </li>
            ))}
          </ul>
        ) : (
          <p>No events registered yet.</p>
        )}
      </div>

      <div className="profile-actions">
        <button
          onClick={() => {
            localStorage.removeItem("token");
            localStorage.removeItem("role");
            window.location.href = "/login";
          }}
          className="logout-btn"
        >
          Logout
        </button>
      </div>
    </div>
  );
};

export default AttendeeProfile;
