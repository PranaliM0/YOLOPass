import React, { useEffect, useState } from 'react';
import VenueForm from './VenueForm';
import axios from 'axios';

const VenueList = () => {
  const [venues, setVenues] = useState([]);
  const [editingVenue, setEditingVenue] = useState(null);

  const token = localStorage.getItem("token"); // Get token from localStorage

  const fetchVenues = async () => {
    try {
      const res = await axios.get('http://localhost:3001/admin/venues', {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      setVenues(res.data);
    } catch (err) {
      console.error('Failed to fetch venues:', err);
    }
  };

  useEffect(() => {
    fetchVenues();
  }, []);

  const handleCreateOrUpdate = async (venue) => {
    try {
      if (venue.id) {
        await axios.put(`http://localhost:3001/admin/venues/${venue.id}`, venue, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });
      } else {
        await axios.post('http://localhost:3001/admin/venues', venue, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });
      }
      fetchVenues();
      setEditingVenue(null);
    } catch (err) {
      alert('Error saving venue');
    }
  };

  const handleDelete = async (id) => {
    if (window.confirm('Are you sure you want to delete this venue?')) {
      try {
        await axios.delete(`http://localhost:3001/admin/venues/${id}`, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });
        fetchVenues();
      } catch (err) {
        console.error('Error deleting venue:', err);
      }
    }
  };

  return (
    <div>
      <h2>Venue Management</h2>
      <VenueForm
        onSubmit={handleCreateOrUpdate}
        currentVenue={editingVenue}
        onCancel={() => setEditingVenue(null)}
      />
      <table>
        <thead>
          <tr>
            <th>Name</th>
            <th>Location</th>
            <th>Capacity</th>
            <th>Description</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {venues.map((venue) => (
            <tr key={venue.id}>
              <td>{venue.name}</td>
              <td>{venue.location}</td>
              <td>{venue.capacity}</td>
              <td>{venue.description}</td>
              <td>
                <button onClick={() => setEditingVenue(venue)}>Edit</button>
                <button onClick={() => handleDelete(venue.id)}>Delete</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default VenueList;
