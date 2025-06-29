import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import '../styles/EventList.css';

const EventList = () => {
  const [events, setEvents] = useState([]);
  const [visibleDescriptions, setVisibleDescriptions] = useState({});
  const navigate = useNavigate();

  useEffect(() => {
    fetchEvents();
  }, []);

  const fetchEvents = async () => {
    try {
      const response = await axios.get('http://localhost:3001/organizer/events', {
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
      });
      setEvents(response.data);
    } catch (error) {
      console.error('Error fetching events:', error);
    }
  };

  const handleCreateEvent = () => {
    navigate('/organizer/create-event');
  };

  // New function to navigate to discount code creation page
  const handleCreateDiscountCode = (eventId) => {
    navigate(`/organizer/create-discount-code/${eventId}`);
  };

  const handleEdit = (eventId) => {
    navigate(`/organizer/edit-event/${eventId}`);
  };

  const handleDelete = async (eventId) => {
    if (window.confirm('Are you sure you want to delete this event?')) {
      try {
        await axios.delete(`http://localhost:3001/organizer/events/${eventId}`, {
          headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
        });
        alert('Event deleted successfully');
        fetchEvents();
      } catch (error) {
        console.error('Error deleting event:', error);
        alert('Failed to delete event.');
      }
    }
  };

  const toggleDescription = (eventId) => {
    setVisibleDescriptions(prev => ({
      ...prev,
      [eventId]: !prev[eventId]
    }));
  };

  return (
    <div className="event-list-container">
      <h2>My Events</h2>
      <button className="create-event-btn" onClick={handleCreateEvent}>Create New Event</button>

      <div className="events">
        {events.length > 0 ? (
          events.map(event => (
            <div key={event.id} className="event-card">
              {/* Event Image (Poster) */}
              {event.image_url && (
                <img src={event.image_url} alt={event.name} className="event-image" />
              )}

              <h3>{event.name}</h3>
              <p><strong>Venue:</strong> {event.venue}</p>
              <p><strong>Start Time:</strong> {new Date(event.start_time).toLocaleString()}</p>
              <p><strong>Status:</strong> {event.status === "open" ? "Open" : "Closed"}</p>
              <p><strong>Category:</strong> {event.category}</p>

              <div className="event-buttons">
                <button className="btn view-btn" onClick={() => toggleDescription(event.id)}>
                  {visibleDescriptions[event.id] ? "Hide Details" : "View Details"}
                </button>
                <button className="btn edit-btn" onClick={() => handleEdit(event.id)}>Edit</button>
                <button className="btn delete-btn" onClick={() => handleDelete(event.id)}>Delete</button>

                {/* Button for creating discount code */}
                <button className="btn discount-btn" onClick={() => handleCreateDiscountCode(event.id)}>
                  Create Discount Code
                </button>
              </div>

              {visibleDescriptions[event.id] && (
                <p><strong>Description:</strong> {event.description}</p>
              )}
            </div>
          ))
        ) : (
          <p>No events found.</p>
        )}
      </div>
    </div>
  );
};

export default EventList;
