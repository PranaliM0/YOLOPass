import React, { useState } from "react";
import axios from "axios";
import { setToken } from "../services/authService";
import { useNavigate } from "react-router-dom";

const Login = () => {
  const [credentials, setCredentials] = useState({ email: "", password: "" });
  const navigate = useNavigate();

  const handleChange = (e) => {
    setCredentials({ ...credentials, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const res = await axios.post("http://localhost:3001/signin", credentials);
      const { token, role } = res.data;

      // Save token and role
      setToken(token);
      localStorage.setItem("role", role);

      alert("Login successful!");

      // Redirect based on user role
      if (role === "admin") {
        navigate("/admin-dashboard");
      } else if (role === "organizer") {
        navigate("/organizer-dashboard");
      } else if (role === "attendee") {
        navigate("/attendee-dashboard");
      } else {
        alert("Invalid role. Redirecting to signup.");
        navigate("/signup");
      }
    } catch (error) {
      alert("Login failed. Please check your credentials.");
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <h2>Login</h2>
      <input
        type="email"
        name="email"
        placeholder="Email"
        value={credentials.email}
        onChange={handleChange}
        required
      />
      <input
        type="password"
        name="password"
        placeholder="Password"
        value={credentials.password}
        onChange={handleChange}
        required
      />
      <button type="submit">Login</button>
    </form>
  );
};

export default Login;
