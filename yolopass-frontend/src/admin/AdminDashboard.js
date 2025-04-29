import React, { useEffect, useState } from "react";
import axios from "axios";
import AdminNavbar from "./AdminNavbar";
import '../styles/AdminStyles.css';

const Dashboard = () => {
  const [stats, setStats] = useState({});

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const token = localStorage.getItem("token");
        const response = await axios.get("http://localhost:3001/admin/stats", {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });
        setStats(response.data);
      } catch (err) {
        console.error("Failed to fetch admin stats", err);
      }
    };

    fetchStats();
  }, []);

  return (
    <div>
      <AdminNavbar />
      <div className="dashboard-wrapper">
        <h1 className="dashboard-title">Admin Dashboard</h1>
        <div className="stats-grid">
          <div className="stat-card">
            <h3>Total Users</h3>
            <p>{stats.total_users || 0}</p>
          </div>
          <div className="stat-card">
            <h3>Total Organizers</h3>
            <p>{stats.total_organizers || 0}</p>
          </div>
          <div className="stat-card">
            <h3>Total Events</h3>
            <p>{stats.total_events || 0}</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
