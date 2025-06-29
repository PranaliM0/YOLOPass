import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useNavigate, useParams } from 'react-router-dom';
import '../styles/CreateDiscountCode.css';

const CreateDiscountCode = () => {
  const [formData, setFormData] = useState({
    code: '',
    discount_type: 'percentage',
    amount: '',
    expires_at: '',
    max_uses: '',
    event_id: ''
  });

  const [error, setError] = useState('');
  const [event, setEvent] = useState(null);
  const [discountCodes, setDiscountCodes] = useState([]);

  const navigate = useNavigate();
  const { event_id } = useParams();

  // First define fetchDiscountCodes
  // Fetch Discount Codes
const fetchDiscountCodes = async () => {
  try {
    const response = await axios.get(`http://localhost:3001/organizer/discount_codes?event_id=${event_id}`, {
      headers: {
        Authorization: `Bearer ${localStorage.getItem('token')}`
      }
    });
    setDiscountCodes(response.data);
  } catch (err) {
    console.error('Error fetching discount codes:', err);
    setError('Failed to fetch discount codes.');
  }
};


  // Then define fetchEvent
  const fetchEvent = async () => {
    try {
      const response = await axios.get(
        `http://localhost:3001/organizer/event_details/${event_id}`,
        {
          headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`
          }
        }
      );
      setEvent(response.data);
      setFormData((prevState) => ({
        ...prevState,
        event_id: response.data.id
      }));
    } catch (err) {
      console.error("Error fetching event details:", err);
      setError('Failed to load event details.');
    }
  };

  // Now use useEffect
  useEffect(() => {
    if (event_id) {
      fetchEvent();
      fetchDiscountCodes();
    }
  }, [event_id]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prevState) => ({
      ...prevState,
      [name]: value
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await axios.post('http://localhost:3001/organizer/discount_codes', formData, {
        headers: {
          Authorization: `Bearer ${localStorage.getItem('token')}`
        }
      });

      alert("Discount code created successfully!");
      fetchDiscountCodes(); // Refresh the list

      setFormData({
        code: '',
        discount_type: 'percentage',
        amount: '',
        expires_at: '',
        max_uses: '',
        event_id: event.id
      });
    } catch (err) {
      setError('Failed to create discount code. Please try again.');
      console.error(err);
    }
  };

  if (!event) return <p>Loading...</p>;
  if (!event.name) return <p>Event details are missing or failed to load.</p>;

  return (
    <div className="discount-code-form-container">
      <h2>Create Discount Code for Event: {event.name}</h2>
      {error && <p className="error-message">{error}</p>}

      <form onSubmit={handleSubmit} className="discount-code-form">
        <div className="form-group">
          <label htmlFor="code">Discount Code</label>
          <input
            type="text"
            id="code"
            name="code"
            value={formData.code}
            onChange={handleChange}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="discount_type">Discount Type</label>
          <select
            id="discount_type"
            name="discount_type"
            value={formData.discount_type}
            onChange={handleChange}
            required
          >
            <option value="percentage">Percentage</option>
            <option value="fixed">Fixed Amount</option>
          </select>
        </div>

        <div className="form-group">
          <label htmlFor="amount">Amount</label>
          <input
            type="number"
            id="amount"
            name="amount"
            value={formData.amount}
            onChange={handleChange}
            min="0.01"
            step="0.01"
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="expires_at">Expiration Date</label>
          <input
            type="datetime-local"
            id="expires_at"
            name="expires_at"
            value={formData.expires_at}
            onChange={handleChange}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="max_uses">Max Uses</label>
          <input
            type="number"
            id="max_uses"
            name="max_uses"
            value={formData.max_uses}
            onChange={handleChange}
            min="1"
            required
          />
        </div>

        <button type="submit" className="btn create-btn">
          Create Discount Code
        </button>
      </form>

      {event && event.early_bird_price && event.early_bird_deadline && (
        <div className="early-bird-discount">
          <h3>🎉 Early Bird Discount</h3>
          <p><strong>Price:</strong> ₹{event.early_bird_price} (Limited time offer)</p>
          <p><strong>Deadline:</strong> {new Date(event.early_bird_deadline).toLocaleDateString()}</p>
        </div>
      )}

      <div className="existing-discount-codes">
        <h3>🎟️ Existing Discount Codes:</h3>
        {discountCodes.length === 0 ? (
          <p>No discount codes created yet.</p>
        ) : (
          <ul>
            {discountCodes.map((code) => (
              <li key={code.id}>
                {code.code} - {code.discount_type === 'percentage' ? `${code.amount}% off` : `₹${code.amount} off`} (Expires: {new Date(code.expires_at).toLocaleDateString()})
                &nbsp;
                <button>Edit</button>
                <button>Delete</button>
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
};

export default CreateDiscountCode;
