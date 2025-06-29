import React, { useEffect, useState } from "react";
import axios from "axios";
import "../styles/ViewOrganizers.css";

const ViewOrganizers = () => {
  const [organizers, setOrganizers] = useState([]);
  const [error, setError] = useState(null);  // To handle errors

  // Get the token from localStorage (or wherever it's stored)
  const token = localStorage.getItem("token"); 

  useEffect(() => {
    axios.get("http://localhost:3001/admin/organizers", {
      headers: {
        Authorization: `Bearer ${token}`,  // Add the token to the Authorization header
      }
    })
      .then(response => {
        setOrganizers(response.data);
      })
      .catch(error => {
        setError("Error fetching organizers.");
        console.log(error);
      });
  }, [token]);  // The token is a dependency

  const handleDelete = (id, name) => {
    const confirmDelete = window.confirm(`Are you sure you want to delete organizer "${name}"?\n\nThis will also delete all events hosted by this organizer!`);
  
    if (confirmDelete) {
      const token = localStorage.getItem('token');
  
      axios.delete(`http://localhost:3001/admin/organizers/${id}`, {
        headers: {
          Authorization: `Bearer ${token}`,
        }
      })
      .then(response => {
        setOrganizers(organizers.filter(org => org.id !== id));
        alert('Organizer and their events deleted successfully.');
      })
      .catch(error => {
        setError("Error deleting organizer.");
        console.log(error);
      });
    }
  };
  
  return (
    <div className="view-organizers">
      <h2>Organizers List</h2>
      {error && <p className="error-message">{error}</p>}
      <table>
        <thead>
          <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          {organizers.map((organizer) => (
            <tr key={organizer.id}>
              <td>{organizer.name}</td>
              <td>{organizer.email}</td>
              <td>
              <button onClick={() => handleDelete(organizer.id, organizer.name)}>Remove</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default ViewOrganizers;
