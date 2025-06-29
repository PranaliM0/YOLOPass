import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import axios from "axios";
import "../styles/RegistrationReview.css";

const RegistrationReview = () => {
  const { registrationId } = useParams();
  const [registration, setRegistration] = useState(null);

  useEffect(() => {
    const fetchRegistration = async () => {
      try {
        const token = localStorage.getItem("token");
        const res = await axios.get(
          `http://localhost:3001/attendee/registrations/${registrationId}`,
          {
            headers: { Authorization: `Bearer ${token}` },
          }
        );
        setRegistration(res.data); // assuming res.data is the registration object
      } catch (error) {
        console.error("Error fetching registration:", error);
      }
    };

    fetchRegistration();
  }, [registrationId]);

  if (!registration) {
    return <div>Loading...</div>;
  }

  return (
    <div className="review-container">
      <h2>Registration Review</h2>

      <h3>Participants</h3>
      <ul>
        {registration.participants?.length > 0 ? (
          registration.participants.map((p, index) => (
            <li key={index}>
              {p.name} ({p.email}) - {p.phone}
            </li>
          ))
        ) : (
          <li>No participants found.</li>
        )}
      </ul>

      <h3>Discount Code</h3>
      <p>{registration.discount_code || "No Discount Applied"}</p>

      <h3>Amount to Pay</h3>
      <p>₹ {registration.amount_paid ?? "Not calculated"}</p>

      <button className="pay-button">Proceed to Pay</button>
    </div>
  );
};

export default RegistrationReview;
