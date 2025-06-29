import React, { useEffect, useState } from 'react';
import { Link} from 'react-router-dom';
import '../styles/Homepage.css';

export default function Homepage() {
  const [featuredEvents, setFeaturedEvents] = useState([]);

  useEffect(() => {
    fetch('http://localhost:3001/homepage/events/featured')
      .then(response => response.json())
      .then(data => setFeaturedEvents(data))
      .catch(error => console.error('Error fetching events:', error));
  }, []);

  return (
    <div className="homepage-container">
      {/* Navbar */}
      <nav className="navbar">
        <div className="navbar-left">YOLOPass</div>
        <div className="navbar-right">
          <Link to="/">Home</Link>
          <a href="#events">Events</a>
          {/* Anchor link for About section */}
          <a href="#about">About</a>  {/* Use anchor link here */}
        </div>
      </nav>

      {/* Hero Section */}
      <div className="hero-section">
        <h1>Welcome to YOLOPass</h1>
        <p>Find, Register, and Enjoy Events</p>
        <Link to="/signup" className="get-started-btn">Get Started</Link>
      </div>

      {/* Events Section */}
      <div className="events-section" id='events'>
        <h2>Featured Events</h2>
        <div className="event-cards">
          {featuredEvents.map((event) => (
            <div className="event-card" key={event.id}>
              <img
                  src={event.image_url || "https://source.unsplash.com/600x300/?event"} // Fallback image if event doesn't have an image
                  alt={event.name}
                  className="event-details-image"
                />
              <h3>{event.title}</h3>
              <p>{event.description}</p>
              {/* <button onClick={() => navigate(`/event/${event.id}`)}>View Details</button> */}
            </div>
          ))}
        </div>
      </div>

      {/* About Section with ID for scrolling */}
      <div className="about-section" id="about"> {/* Add id="about" here */}
        <h2>About YOLOPass</h2>
        <p>YOLOPass is an innovative platform designed to simplify the process of discovering and registering for events. Whether you're looking for conferences, concerts, workshops, or networking meetups, YOLOPass connects you with a wide variety of events that match your interests. Our goal is to provide a seamless and intuitive experience that allows you to easily find, register, and enjoy events that matter to you. With YOLOPass, you can stay updated on the latest happenings, never miss out on opportunities, and make the most of every event you attend. Join us and discover a world of possibilities at your fingertips! We are committed to bringing you the most relevant and exciting events from all over, helping you create unforgettable experiences and memories.</p>
      </div>

      {/* Footer */}
      <footer className="footer">
        <p>Connect with us:</p>
        <div className="social-media">
          <a href="https://facebook.com">Facebook</a>
          <a href="https://twitter.com">Twitter</a>
          <a href="https://instagram.com">Instagram</a>
        </div>
      </footer>
    </div>
  );
}
