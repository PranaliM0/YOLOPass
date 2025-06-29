import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import '../styles/CreateEvent.css';

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
    image: null
  });

  const [availableVenues, setAvailableVenues] = useState([]);
  const [selectedVenueCapacity, setSelectedVenueCapacity] = useState(null);

  const navigate = useNavigate();

  const fetchAvailableVenues = async (start_time, end_time) => {
    try {
      const response = await axios.get('http://localhost:3001/organizer/available_venues', {
        params: {
          start_time,
          end_time
        },
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('token')}`,
        }
      });
      setAvailableVenues(response.data); 
    } catch (error) {
      console.error('Error fetching available venues:', error);
    }
  };

  const handleChange = (e) => {
    const { name, value, files } = e.target;

    if (name === 'image') {
      setEventData(prevState => ({
        ...prevState,
        image: files[0],
      }));
    } else if (name === 'venue') {
      const selectedVenue = availableVenues.find(v => v.name === value);
      setSelectedVenueCapacity(selectedVenue?.capacity || null);

      setEventData(prevState => ({
        ...prevState,
        venue: value,
      }));
    } else {
      const updatedEventData = {
        ...eventData,
        [name]: value,
      };
      setEventData(updatedEventData);

      if ((name === 'start_time' || name === 'end_time') && updatedEventData.start_time && updatedEventData.end_time) {
        fetchAvailableVenues(updatedEventData.start_time, updatedEventData.end_time);
      }
    }
  };

  const handleCheckboxChange = (e) => {
    setEventData({
      ...eventData,
      [e.target.name]: e.target.checked
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    if (
      selectedVenueCapacity &&
      parseInt(eventData.max_participants) > selectedVenueCapacity
    ) {
      alert(`Max participants cannot exceed venue capacity of ${selectedVenueCapacity}`);
      return;
    }

    const formData = new FormData();
    for (let key in eventData) {
      formData.append(`event[${key}]`, eventData[key]);
    }

    axios.post('http://localhost:3001/organizer/events', formData, {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('token')}`,
        'Content-Type': 'multipart/form-data'
      }
    })
    .then(response => {
      alert("Event created successfully!");
      navigate('/events');
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
          Venue:
          <select 
            name="venue" 
            value={eventData.venue} 
            onChange={handleChange} 
            required
            disabled={availableVenues.length === 0}
          >
            <option value="">Select a venue</option>
            {availableVenues.map(venue => (
              <option key={venue.id} value={venue.name}>
                {venue.name} (Capacity: {venue.capacity})
              </option>
            ))}
          </select>
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
          Early Bird Discount (%):
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

        <label>
          Event Image:
          <input 
            type="file" 
            name="image" 
            accept="image/*"
            onChange={handleChange} 
            required
          />
        </label>

        <button type="submit" className="submit-btn">Create Event</button>
      </form>
    </div>
  );
};

export default CreateEvent;
