import React, { useState, useEffect } from "react";
import { useNavigate, useParams } from "react-router-dom";
import "../styles/AttendeeEventRegistrationForm.css";

// Participant Form Component
const ParticipantForm = ({ index, participant, onChange, onFileChange }) => (
  <div className="participant-section">
    <h3>Participant {index + 1}</h3>
    <div className="form-group">
      <label>Name</label>
      <input
        type="text"
        value={participant.name}
        onChange={(e) => onChange(index, "name", e.target.value)}
        required
      />
    </div>

    <div className="form-group">
      <label>Email</label>
      <input
        type="email"
        value={participant.email}
        onChange={(e) => onChange(index, "email", e.target.value)}
        required
      />
    </div>

    <div className="form-group">
      <label>Phone</label>
      <input
        type="tel"
        value={participant.phone}
        onChange={(e) => onChange(index, "phone", e.target.value)}
        required
      />
    </div>

    <div className="form-group">
      <label>ID Proof Type</label>
      <select
        value={participant.id_proof_type}
        onChange={(e) => onChange(index, "id_proof_type", e.target.value)}
        required
      >
        <option value="">Select ID Proof Type</option>
        <option value="Aadhar">Aadhar</option>
        <option value="Passport">Passport</option>
        <option value="Driving License">Driving License</option>
        <option value="Voter ID">Voter ID</option>
        <option value="Other">Other</option>
      </select>
    </div>
    
    <div className="form-group">
      <label>Upload ID Proof</label>
      <input
        type="file"
        accept="image/*,.pdf"
        onChange={(e) => onFileChange(index, e.target.files[0])}
        required
      />
    </div>
  </div>
);

const EventRegistrationForm = () => {
  const { eventId } = useParams(); // Get eventId from URL
  const navigate = useNavigate();

  // States
  const [participants, setParticipants] = useState([
    { name: "", email: "", phone: "", id_proof_type: "", uploaded_id: null },
  ]);
  const [discountCode, setDiscountCode] = useState("");
  const [paymentMethod, setPaymentMethod] = useState("upi");
  const [discountCodes, setDiscountCodes] = useState([]);

  useEffect(() => {
    const fetchDiscountCodes = async () => {
      try {
        const token = localStorage.getItem("token");
        const res = await fetch(`http://localhost:3001/attendee/discount_codes?event_id=${eventId}`, {
          headers: {
            "Authorization": `Bearer ${token}`,
          },
        });
  
        const data = await res.json();
  
        if (data?.codes) {
          setDiscountCodes(data.codes); 
        } else {
          setDiscountCodes([]); 
        }
      } catch (error) {
        console.error("Error fetching discount codes:", error);
        setDiscountCodes([]);
      }
    };
  
    fetchDiscountCodes();
  }, [eventId]);
  

  // Handle Participant Form Changes
  const handleParticipantChange = (index, field, value) => {
    const updatedParticipants = [...participants];
    updatedParticipants[index][field] = value;
    setParticipants(updatedParticipants);
  };

  const handleFileChange = (index, file) => {
    const updatedParticipants = [...participants];
    updatedParticipants[index].uploaded_id = file;
    setParticipants(updatedParticipants);
  };

  // Handle adding new participants
  const handleAddParticipants = (count) => {
    const newParticipants = Array.from({ length: count }, (_, i) =>
      participants[i] || { name: "", email: "", phone: "", id_proof_type: "", uploaded_id: null }
    );
    setParticipants(newParticipants);
  };

  // Form Submit Handler
  const handleSubmit = async (e) => {
    e.preventDefault();

    const formData = new FormData();
    formData.append("registration[event_id]", eventId);
    formData.append("registration[discount_code]", discountCode);
    formData.append("registration[payment_method]", paymentMethod);
    formData.append("registration[number_of_participants]", participants.length);

    participants.forEach((p, i) => {
      formData.append(`registration[participants][${i}][name]`, p.name);
      formData.append(`registration[participants][${i}][email]`, p.email);
      formData.append(`registration[participants][${i}][phone]`, p.phone);
      formData.append(`registration[participants][${i}][id_proof_type]`, p.id_proof_type);

      if (p.uploaded_id) {
        formData.append(`registration[participants][${i}][uploaded_id]`, p.uploaded_id);
      }
    });

    try {
      const token = localStorage.getItem("token"); // JWT Token
      const res = await fetch("http://localhost:3001/attendee/registrations", {
        method: "POST",
        headers: { "Authorization": `Bearer ${token}` },
        body: formData,
      });

      const data = await res.json();
      if (data.registration_id) {
        navigate(`/attendee/review/${data.registration_id}`);
      } else {
        alert("Registration failed. Please try again.");
      }
    } catch (error) {
      console.error("Error during registration:", error);
      alert("Something went wrong. Try again later.");
    }
  };

  return (
    <div className="registration-container">
      <h2>Event Registration</h2>
      <form onSubmit={handleSubmit} className="registration-form">
        <div className="form-group">
          <label>Number of Participants</label>
          <input
            type="number"
            min="1"
            max="10"
            value={participants.length}
            onChange={(e) => handleAddParticipants(parseInt(e.target.value))}
            required
          />
        </div>

        {participants.map((participant, index) => (
          <ParticipantForm
            key={index}
            index={index}
            participant={participant}
            onChange={handleParticipantChange}
            onFileChange={handleFileChange}
          />
        ))}

        <div className="form-group">
          <label>Discount Code (Optional)</label>
          <select
            value={discountCode}
            onChange={(e) => setDiscountCode(e.target.value)}
          >
            <option value="">Select a discount code</option>
            {discountCodes.length > 0 ? (
              discountCodes.map((code) => (
                <option key={code.id} value={code.code}>
                  {code.code}
                </option>
              ))
            ) : (
              <option disabled>No discount codes available for this event</option>
            )}
          </select>
        </div>

        <div className="form-group">
          <label>Payment Method</label>
          <select
            value={paymentMethod}
            onChange={(e) => setPaymentMethod(e.target.value)}
          >
            <option value="upi">UPI</option>
            <option value="credit_card">Credit Card</option>
          </select>
        </div>

        <button type="submit" className="submit-button">
          Save and Proceed to Review
        </button>
      </form>
    </div>
  );
};

export default EventRegistrationForm;
