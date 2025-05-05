import React, { useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";

const Signup = () => {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    password: "",
    password_confirmation: "",
    role: "attendee",
  });

  const navigate = useNavigate();

  const handleChange = (e) => {
    setFormData({...formData, [e.target.name]: e.target.value});
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await axios.post("http://localhost:3001/signup", { user: formData });
      alert("Signup successful. Please log in.");
      navigate("/login");
    } catch (error) {
      alert("Signup failed.");
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <h2>Signup</h2>
      <input type="text" name="name" placeholder="Name" onChange={handleChange} required />
      <input type="email" name="email" placeholder="Email" onChange={handleChange} required />
      <input type="password" name="password" placeholder="Password" onChange={handleChange} required />
      <input type="password" name="password_confirmation" placeholder="Confirm Password" onChange={handleChange} required />
      <select name="role" onChange={handleChange}>
        <option value="attendee">Attendee</option>
        <option value="organizer">Organizer</option>
        <option value="admin">Admin</option>
      </select>
      <button type="submit">Signup</button>
      <p className="mt-4 text-center">
  Already have an account?{" "}
  <a href="/login" className="text-blue-600 hover:underline">
    Sign In here
  </a>
</p>

    </form>
  );
};

export default Signup;
