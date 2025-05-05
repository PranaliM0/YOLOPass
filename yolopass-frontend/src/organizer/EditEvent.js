import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { useParams, useNavigate } from 'react-router-dom';
import '../styles/EditEvent.css';

const EditEvent = () => {
  const { eventId } = useParams();
  const navigate = useNavigate();

  const [eventData, setEventData] = useState({
    name: '',
    venue: '',
    start_time: '',
    description: '',
    status: 'open',
    category: '',
    early_bird_discount: '',
    price: ''
  });

  useEffect(() => {
    const fetchEvent = async () => {
      try {
        const response = await axios.get(`http://localhost:3001/organizer/events/${eventId}`, {
          headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
        });
        const data = response.data;
        setEventData({
          name: data.name,
          venue: data.venue,
          start_time: new Date(data.start_time).toISOString().slice(0, 16),
          description: data.description,
          status: data.status,
          category: data.category,
          early_bird_discount: data.early_bird_discount,
          price: data.price 
        });
      } catch (error) {
        console.error('Error fetching event:', error);
        alert('Could not fetch event data.');
      }
    };
  
    fetchEvent();
  }, [eventId]);
  

  const handleChange = (e) => {
    setEventData({ ...eventData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await axios.put(`http://localhost:3001/organizer/events/${eventId}`, eventData, {
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
      });
      alert('Event updated successfully!');
      navigate('/organizer/events');
    } catch (error) {
      console.error('Error updating event:', error);
      alert('Failed to update event.');
    }
  };

  return (
    <div className="edit-event-container">
      <h2>Edit Event</h2>
      <form className="edit-event-form" onSubmit={handleSubmit}>
        <label>
          Name:
          <input type="text" name="name" value={eventData.name} onChange={handleChange} required />
        </label>

        <label>
          Venue:
          <input type="text" name="venue" value={eventData.venue} onChange={handleChange} required />
        </label>

        <label>
          Start Time:
          <input type="datetime-local" name="start_time" value={eventData.start_time} onChange={handleChange} required />
        </label>

        <label>
          Category:
          <input type="text" name="category" value={eventData.category} onChange={handleChange} required />
        </label>

        <label>
          Status:
          <select name="status" value={eventData.status} onChange={handleChange}>
            <option value="open">Open</option>
            <option value="closed">Closed</option>
          </select>
        </label>

        <label>
          Description:
          <textarea name="description" value={eventData.description} onChange={handleChange} required />
        </label>
        <label>
          Early Bird Discount (%):
          <input
            type="number"
            name="early_bird_discount"
            value={eventData.early_bird_discount}
            onChange={handleChange}
            min="0"
            max="100"
            placeholder="0"
          />
        </label>

        <label>
          Price:
          <input
            type="number"
            name="price"
            value={eventData.price}
            onChange={handleChange}
            min="0"
            placeholder="Event price"
            required
          />
        </label>

        <button type="submit" className="update-btn">Update Event</button>
      </form>
    </div>
  );
};

export default EditEvent;
