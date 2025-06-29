import React, { useEffect, useState } from "react";
import axios from "axios";
import "../styles/CartPage.css"; // optional for styling

const CartPage = () => {
  const [registrations, setRegistrations] = useState([]);
  const [selectedReview, setSelectedReview] = useState(null);

  useEffect(() => {
    const fetchCart = async () => {
      try {
        const token = localStorage.getItem("token");
        const response = await axios.get(
          "http://localhost:3000/attendee/registrations",
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );
        setRegistrations(response.data);
      } catch (error) {
        console.error("Error fetching registrations:", error);
      }
    };

    fetchCart();
  }, []);

  const fetchReview = async (registrationId) => {
    try {
      const token = localStorage.getItem("token");
      const response = await axios.get(
        `http://localhost:3000/attendee/review/${registrationId}`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      setSelectedReview(response.data);
    } catch (error) {
      console.error("Error fetching review:", error);
      setSelectedReview({ error: "No review found or error occurred." });
    }
  };

  return (
    <div className="cart-container">
      <h2>My Event Registrations</h2>
      {registrations.length === 0 ? (
        <p>No registrations yet.</p>
      ) : (
        registrations.map((registration) => (
          <div key={registration.id} className="registration-card">
            <h3>{registration.event.name}</h3>
            <p>Date: {registration.event.start_time?.slice(0, 10)}</p>
            <p>Venue: {registration.event.venue}</p>
            <p>Amount Paid: ₹{registration.amount_paid}</p>
            <button
              onClick={() => fetchReview(registration.id)}
              className="review-btn"
            >
              View Review
            </button>

            {selectedReview && selectedReview.registration_id === registration.id && (
              <div className="review-box">
                <h4>Review</h4>
                <p>{selectedReview.content}</p>
              </div>
            )}
          </div>
        ))
      )}
    </div>
  );
};

export default CartPage;
