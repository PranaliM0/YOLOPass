import React, { useState, useEffect, useCallback } from "react";
import axios from "axios";
import "../styles/AttendeeDashboard.css";

const AttendeeDashboard = () => {
  const [allEvents, setAllEvents] = useState({});
  const [filteredEvents, setFilteredEvents] = useState({});
  const [showFilters, setShowFilters] = useState(false);

  const [filters, setFilters] = useState({
    category: "",
    venue: "",
    price: "",
  });

  const fetchEvents = async () => {
    try {
      const token = localStorage.getItem("token");
      const res = await axios.get(
        "http://localhost:3001/attendee/attendees/events_grouped_by_category",
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      setAllEvents(res.data);
      setFilteredEvents(res.data);
    } catch (error) {
      console.error("Error fetching events:", error);
    }
  };

  useEffect(() => {
    fetchEvents();
  }, []);

  const filterEvents = useCallback(() => {
    const { category, venue, price } = filters;
    const newFilteredEvents = {};

    Object.entries(allEvents).forEach(([cat, events]) => {
      if (category && category.toLowerCase() !== cat.toLowerCase()) return;

      const filtered = events.filter((event) => {
        const matchesVenue = venue
          ? event.venue.toLowerCase().includes(venue.toLowerCase())
          : true;
        const matchesPrice = price ? event.price <= parseFloat(price) : true;
        return matchesVenue && matchesPrice;
      });

      if (filtered.length > 0) newFilteredEvents[cat] = filtered;
    });

    setFilteredEvents(newFilteredEvents);
  }, [filters, allEvents]);

  useEffect(() => {
    filterEvents();
  }, [filters, allEvents, filterEvents]);

  const handleFilterChange = (e) => {
    setFilters({ ...filters, [e.target.name]: e.target.value });
  };

  return (
    <div className="dashboard-container">
      <nav className="navbar">
        <div className="navbar-logo">YOLOPass</div>

        <div className="navbar-buttons">
  <button onClick={() => (window.location.href = "/attendee/profile")}>
    Profile
          </button>
          {}
          <button
            onClick={() => {
              localStorage.removeItem("token");
              localStorage.removeItem("role");
              window.location.href = "/login";
            }}
          >
            Logout
          </button>

        </div>

        <div className="navbar-filters">
          <button
            className="filter-toggle"
            onClick={() => setShowFilters(!showFilters)}
          >
            Filters ⌄
          </button>
          {showFilters && (
            <div className="filter-dropdown">
              <input
                type="text"
                name="category"
                placeholder="Category"
                value={filters.category}
                onChange={handleFilterChange}
              />
              <input
                type="text"
                name="venue"
                placeholder="Venue"
                value={filters.venue}
                onChange={handleFilterChange}
              />
              <input
                type="number"
                name="price"
                placeholder="Max Price"
                value={filters.price}
                onChange={handleFilterChange}
              />
            </div>
          )}
        </div>
      </nav>

      <div className="category-title">Top Events</div>

      {Object.keys(filteredEvents).length > 0 ? (
        Object.entries(filteredEvents).map(([category, events]) => (
          <div key={category}>
            <h2 className="category-heading">{category}</h2>
            <div className="event-grid">
              {events.slice(0, 3).map((event) => (
                <div key={event.id} className="event-card">
                  {event.image_url && (
                    <img
                      src={event.image_url}
                      alt={event.name}
                      className="event-image"
                    />
                  )}
                  <div className="event-card-body">
                    <div className="event-card-title">{event.name}</div>
                    <div className="event-card-meta">{event.venue}</div>
                    <div className="event-card-meta">
                      Date: {event.start_time?.slice(0, 10)}
                    </div>
                    <div className="event-card-meta">₹{event.price || 0}</div>
                    <button
                      className="event-card-button"
                      onClick={() =>
                        (window.location.href = `/attendee/events/${event.id}`)
                      }
                    >
                      View Details
                    </button>
                  </div>
                </div>
              ))}
            </div>
            <div className="see-more-container">
              <a
                href={`/attendee/events/category/${encodeURIComponent(
                  category
                )}`}
                className="see-more-link"
              >
                See more
              </a>
            </div>
          </div>
        ))
      ) : (
        <p className="no-events-message">No events found for the filters.</p>
      )}
    </div>
  );
};

export default AttendeeDashboard;
