import React, { useState, useEffect } from 'react';
import axios from 'axios';
import "../styles/ViewEvents.css";


const ViewEvents = () => {
  const [groupedEvents, setGroupedEvents] = useState({});
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchEvents = async () => {
      try {
        const token = localStorage.getItem('token');
        const config = {
          headers: { Authorization: `Bearer ${token}` },
        };
        
        const response = await axios.get('http://localhost:3001/admin/events', config);

        // Group events by organizer
        const events = response.data;
        const grouped = {};

        events.forEach(event => {
          const organizerId = event.organizer.id;
          if (!grouped[organizerId]) {
            grouped[organizerId] = {
              organizer: event.organizer,
              events: [],
            };
          }
          grouped[organizerId].events.push(event);
        });

        setGroupedEvents(grouped);
        setLoading(false);
      } catch (error) {
        console.error('Error fetching events:', error);
        setLoading(false);
      }
    };

    fetchEvents();
  }, []);

  const handleDelete = async (eventId) => {
    if (!window.confirm("Are you sure you want to delete this event?")) return;
    
    try {
      const token = localStorage.getItem('token');
      const config = {
        headers: { Authorization: `Bearer ${token}` },
      };

      await axios.delete(`http://localhost:3001/admin/events/${eventId}`, config);

      // After deletion, update the UI
      const updatedGroupedEvents = { ...groupedEvents };
      for (const organizerId in updatedGroupedEvents) {
        updatedGroupedEvents[organizerId].events = updatedGroupedEvents[organizerId].events.filter(event => event.id !== eventId);
      }
      setGroupedEvents(updatedGroupedEvents);

      alert("Event deleted successfully!");
    } catch (error) {
      console.error('Error deleting event:', error);
      alert("Failed to delete event.");
    }
  };

  if (loading) {
    return <p>Loading...</p>;
  }

  return (
    <div className="view-events">
      <h2>View Events by Organizer</h2>
      {Object.values(groupedEvents).map(({ organizer, events }) => (
        <div key={organizer.id} className="organizer-section">
          <h3>{organizer.name} ({organizer.email})</h3>
          {events.length === 0 ? (
            <p>No events for this organizer.</p>
          ) : (
            <table className="event-table">
              <thead>
                <tr>
                  <th>Event Name</th>
                  <th>Venue</th>
                  <th>Category</th>
                  <th>Start Time</th>
                  <th>Status</th>
                  <th>Action</th>
                </tr>
              </thead>
              <tbody>
                {events.map(event => (
                  <tr key={event.id}>
                    <td>{event.name}</td>
                    <td>{event.venue}</td>
                    <td>{event.category}</td>
                    <td>{new Date(event.start_time).toLocaleString()}</td>
                    <td>{event.status}</td>
                    <td>
                      <button onClick={() => handleDelete(event.id)} className="delete-button">
                        Delete
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      ))}
    </div>
  );
};

export default ViewEvents;
