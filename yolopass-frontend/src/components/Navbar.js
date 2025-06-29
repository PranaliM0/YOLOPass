import React from 'react';
import { Link } from 'react-router-dom';
import '../styles/Navbar.css';

export default function Navbar() {
  return (
    <nav className="simple-navbar">
      <div className="nav-left">
        <Link to="/" className="logo">YOLOPass</Link>
      </div>
      <div className="nav-right">
        <Link to="/">About</Link>
        <Link to="/">Home</Link>
        <Link to="/events">Events</Link>
        <Link to="/signup" className="get-started">Get Started</Link>
      </div>
    </nav>
  );
}
