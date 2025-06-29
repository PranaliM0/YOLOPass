import React, { useState, useEffect } from 'react';

const VenueForm = ({ onSubmit, currentVenue, onCancel }) => {
  const [venue, setVenue] = useState({
    name: '',
    location: '',
    capacity: '',
    description: ''
  });

  useEffect(() => {
    if (currentVenue) {
      setVenue(currentVenue);
    }
  }, [currentVenue]);

  const handleChange = (e) => {
    setVenue({ ...venue, [e.target.name]: e.target.value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    onSubmit(venue);
    setVenue({ name: '', location: '', capacity: '', description: '' });
  };

  return (
    <form onSubmit={handleSubmit} style={{ marginBottom: '20px' }}>
      <input type="text" name="name" placeholder="Venue Name" value={venue.name} onChange={handleChange} required />
      <input type="text" name="location" placeholder="Location" value={venue.location} onChange={handleChange} required />
      <input type="number" name="capacity" placeholder="Capacity" value={venue.capacity} onChange={handleChange} />
      <textarea name="description" placeholder="Description" value={venue.description} onChange={handleChange}></textarea>
      <button type="submit">{currentVenue ? 'Update Venue' : 'Add Venue'}</button>
      {currentVenue && <button type="button" onClick={onCancel}>Cancel</button>}
    </form>
  );
};

export default VenueForm;
