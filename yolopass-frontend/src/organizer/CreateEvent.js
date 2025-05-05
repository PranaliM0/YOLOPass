import React, { useState } from 'react';
import axios from 'axios';
import {useNavigate } from 'react-router-dom';

const CreateEvent = () => {
  const [eventData, setEventData] = useState({
    name: '',
    description: '',
    venue: '',
    start_time: '',
    end_time: '',
    category: 'tech',
    subcategory: '',
    price: '',
    early_bird_discount: '',
    early_bird_deadline: '',
    max_participants: '',
    id_proof_required: false,
  });
  const navigate = useNavigate();

  const handleChange = (e) => {
    const { name, value } = e.target;
    setEventData(prevState => ({
      ...prevState,
      [name]: value
    }));
  };

  const handleCheckboxChange = (e) => {
    setEventData({
      ...eventData,
      [e.target.name]: e.target.checked
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    axios.post('http://localhost:3001/organizer/events', { event: eventData }, {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
    })
    .then(response => {
      alert("Event created successfully!");
      navigate('/events'); // correct redirect
    })
    
      .catch(error => {
        console.error('There was an error creating the event!', error);
      });
  };

  return (
    <div className="create-event-container">
      <h2>Create New Event</h2>
      <form onSubmit={handleSubmit} className="create-event-form">
        <label>
          Event Name:
          <input 
            type="text" 
            name="name" 
            value={eventData.name} 
            onChange={handleChange} 
            required
          />
        </label>

        <label>
          Description:
          <textarea 
            name="description" 
            value={eventData.description} 
            onChange={handleChange} 
            required
          />
        </label>

        <label>
          Venue:
          <input 
            type="text" 
            name="venue" 
            value={eventData.venue} 
            onChange={handleChange} 
            required
          />
        </label>

        <label>
          Start Time:
          <input 
            type="datetime-local" 
            name="start_time" 
            value={eventData.start_time} 
            onChange={handleChange} 
            required
          />
        </label>

        <label>
          End Time:
          <input 
            type="datetime-local" 
            name="end_time" 
            value={eventData.end_time} 
            onChange={handleChange} 
            required
          />
        </label>

        <label>
          Category:
          <select name="category" value={eventData.category} onChange={handleChange}>
            <option value="tech">Tech</option>
            <option value="concerts">Concerts</option>
            <option value="art">Art</option>
          </select>
        </label>

        <label>
          Subcategory:
          <input 
            type="text" 
            name="subcategory" 
            value={eventData.subcategory} 
            onChange={handleChange} 
          />
        </label>

        <label>
          Price:
          <input 
            type="number" 
            name="price" 
            value={eventData.price} 
            onChange={handleChange} 
            step="0.01"
            required
          />
        </label>

        <label>
          Early Bird Discount(%):
          <input 
            type="number" 
            name="early_bird_discount" 
            value={eventData.early_bird_discount} 
            onChange={handleChange} 
            step="0.01"
          />

        </label>

        <label>
          Early Bird Deadline:
          <input 
            type="datetime-local" 
            name="early_bird_deadline" 
            value={eventData.early_bird_deadline} 
            onChange={handleChange} 
          />
        </label>

        <label>
          Max Participants:
          <input 
            type="number" 
            name="max_participants" 
            value={eventData.max_participants} 
            onChange={handleChange} 
            required
          />
        </label>

        <label>
          ID Proof Required:
          <input 
            type="checkbox" 
            name="id_proof_required" 
            checked={eventData.id_proof_required} 
            onChange={handleCheckboxChange}
          />
        </label>

        <button type="submit" className="submit-btn">Create Event</button>
      </form>
    </div>
  );
};

export default CreateEvent;
