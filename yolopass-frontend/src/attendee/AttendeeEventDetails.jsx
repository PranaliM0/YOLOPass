import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import axios from "axios";
import "../styles/AttendeeEventDetails.css";
import EventRegistrationForm from "./EventRegistration"; // ✅ Import form

const AttendeeEventDetails = () => {
  const { eventId } = useParams();
  const [event, setEvent] = useState(null);
  const [discountCodes, setDiscountCodes] = useState([]);
  const [showForm, setShowForm] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchEvent = async () => {
      try {
        const token = localStorage.getItem("token");
        const res = await axios.get(
          `http://localhost:3001/attendee/events/${eventId}`,
          {
            headers: { Authorization: `Bearer ${token}` },
          }
        );
        setEvent(res.data.event);
        setDiscountCodes(res.data.discount_codes || []);
      } catch (error) {
        console.error("Error fetching event:", error);
      }
    };

    fetchEvent();
  }, [eventId]);

  if (!event) return <p>Loading event details...</p>;

  return (
    <div className="event-details-container">
      <h2>{event.name}</h2>
      {/* Displaying the event image */}
      <img
        src={event.image_url || "https://source.unsplash.com/600x300/?event"} // Fallback image if event doesn't have an image
        alt={event.name}
        className="event-details-image"
      />
      <div className="event-details-info">
        <p><strong>Category:</strong> {event.category}</p>
        <p><strong>Venue:</strong> {event.venue}</p>
        <p><strong>Start Time:</strong> {new Date(event.start_time).toLocaleString()}</p>
        <p><strong>End Time:</strong> {new Date(event.end_time).toLocaleString()}</p>
        <p><strong>Price:</strong> ₹{event.price}</p>
        <p><strong>Description:</strong> {event.description}</p>

        {/* Display Register button or Registration form */}
        {!showForm ? (
          <button className="register-button" onClick={() => setShowForm(true)}>
            Register
          </button>
        ) : (
          <EventRegistrationForm
            eventId={eventId}
            discountCodes={discountCodes}
            onSuccess={() => navigate("/attendee/dashboard")}
          />
        )}
      </div>
    </div>
  );
};

export default AttendeeEventDetails;
