import React, { useEffect, useState } from 'react';
import axios from 'axios';
import '../styles/AdminStyles.css';

const AdminOrganizerList = () => {
  const [organizers, setOrganizers] = useState([]);

  useEffect(() => {
    fetchOrganizers();
  }, []);

  const fetchOrganizers = async () => {
    try {
      const token = localStorage.getItem('token');
      const response = await axios.get('http://localhost:3001/admin/organizers', {
        headers: { Authorization: `Bearer ${token}` }
      });
      setOrganizers(response.data);
    } catch (err) {
      console.error('Failed to fetch organizers', err);
    }
  };

  const deleteOrganizer = async (organizerId) => {
    if (window.confirm('Are you sure you want to delete this organizer?')) {
      try {
        await axios.delete(`http://localhost:3001/admin/organizers/${organizerId}`, {
          headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
        });
        fetchOrganizers(); // Refresh list
      } catch (err) {
        alert('Failed to delete organizer');
      }
    }
  };

  const deleteEvent = async (eventId) => {
    if (window.confirm('Are you sure you want to delete this event?')) {
      try {
        await axios.delete(`http://localhost:3001/admin/events/${eventId}`, {
          headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
        });
        fetchOrganizers(); // Refresh list
      } catch (err) {
        alert('Failed to delete event');
      }
    }
  };

  return (
    <div className="admin-organizer-container">
      <h2>Organizer List</h2>
      {organizers.map(org => (
        <div key={org.id} className="organizer-card">
          <div className="organizer-header">
            <h3>{org.name} ({org.email})</h3>
            <button className="delete-btn" onClick={() => deleteOrganizer(org.id)}>Delete Organizer</button>
          </div>
          {org.events.length > 0 ? (
            <ul>
              {org.events.map(ev => (
                <li key={ev.id}>
                  <strong>{ev.name}</strong> at {ev.venue}
                  <button className="delete-btn" onClick={() => deleteEvent(ev.id)}>Delete Event</button>
                </li>
              ))}
            </ul>
          ) : (
            <p>No events</p>
          )}
        </div>
      ))}
    </div>
  );
};

export default AdminOrganizerList;
