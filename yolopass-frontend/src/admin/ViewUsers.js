import React, { useEffect, useState } from "react";
import axios from "axios";
import "../styles/ViewUsers.css";

const ViewUsers = () => {
  const [eventRegistrations, setEventRegistrations] = useState([]);
  const [unregisteredUsers, setUnregisteredUsers] = useState([]);

  useEffect(() => {
    const fetchUsersAndRegistrations = async () => {
      try {
        const token = localStorage.getItem('token'); // Assuming you need auth
    
        const config = {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        };
    
        const registrationsRes = await axios.get("http://localhost:3001/admin/event_registrations", config);
        const unregisteredRes = await axios.get("http://localhost:3001/admin/unregistered_users", config);
    
        if (Array.isArray(registrationsRes.data)) {
          setEventRegistrations(registrationsRes.data); // Events and registered users
        } else {
          console.error("Event registrations data is not an array", registrationsRes.data);
        }
    
        if (Array.isArray(unregisteredRes.data)) {
          setUnregisteredUsers(unregisteredRes.data); // Users without registration
        } else {
          console.error("Unregistered users data is not an array", unregisteredRes.data);
        }
    
      } catch (error) {
        console.error("Error fetching users and registrations:", error);
      }    
    };

    fetchUsersAndRegistrations();
  }, []);

  const handleDeleteUser = (id) => {
    const confirmDelete = window.confirm("Are you sure you want to delete this user?");
    if (confirmDelete) {
      const token = localStorage.getItem('token');
      axios.delete(`http://localhost:3001/admin/users/${id}`, {
        headers: {
          Authorization: `Bearer ${token}`,
        }
      })
      .then(() => {
        setEventRegistrations(prev =>
          prev.map(event => ({
            ...event,
            users: event.users.filter(user => user.id !== id),
          }))
        );
        setUnregisteredUsers(prev => prev.filter(user => user.id !== id));
        alert('User deleted successfully.');
      })
      .catch(error => console.log(error));
    }
  };

  return (
    <div className="view-users">
      <h2>Event Registrations</h2>
      {eventRegistrations && Array.isArray(eventRegistrations) && eventRegistrations.length > 0 ? (
        eventRegistrations.map(event => (
          <div key={event.id} className="event-block">
            <h3>{event.name}</h3>
            {event.users && Array.isArray(event.users) && event.users.length > 0 ? (
              <table>
                <thead>
                  <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  {event.users.map(user => (
                    <tr key={user.id}>
                      <td>{user.name}</td>
                      <td>{user.email}</td>
                      <td>
                        <button onClick={() => handleDeleteUser(user.id)}>Remove</button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            ) : (
              <p>No users registered yet.</p>
            )}
          </div>
        ))
      ) : (
        <p>Loading event registrations...</p>
      )}
  
      <h2>Users Not Registered to Any Event</h2>
      {unregisteredUsers && Array.isArray(unregisteredUsers) && unregisteredUsers.length > 0 ? (
        <table>
          <thead>
            <tr>
              <th>Name</th>
              <th>Email</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {unregisteredUsers.map(user => (
              <tr key={user.id}>
                <td>{user.name}</td>
                <td>{user.email}</td>
                <td>
                  <button onClick={() => handleDeleteUser(user.id)}>Remove</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      ) : (
        <p>Loading users...</p>
      )}
    </div>
  );  
};

export default ViewUsers;
