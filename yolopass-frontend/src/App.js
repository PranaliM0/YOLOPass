import React from 'react';
import './App.css';
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Signup from "./components/Signup";
import Login from "./components/Login";
import ProtectedRoute from "./components/ProtectedRoute";

// Dashboards
import AdminDashboard from './admin/AdminDashboard';
import OrganizerDashboard from './organizer/OrganizerDashboard';
import AttendeeDashboard from './attendee/AttendeeDashboard';
import AdminOrganizerList from './admin/AdminOrganizerList';

// Organizer Components
import EventList from './organizer/EventList';
import CreateEvent from './organizer/CreateEvent';
import OrganizerProfile from './organizer/OrganizerProfile';
import EditEvent from './organizer/EditEvent';



function App() {
  return (
    <Router>
      <Routes>
        {/* Public Routes */}
        <Route path="/" element={<Signup />} />
        <Route path="/signup" element={<Signup />} />
        <Route path="/login" element={<Login />} />

        {/* Admin Dashboard */}
        <Route
          path="/admin-dashboard"
          element={
            <ProtectedRoute allowedRoles={["admin"]}>
              <AdminDashboard />
            </ProtectedRoute>
          }
        />

        {/* Organizer Dashboard & Event Routes */}
        <Route
          path="/organizer-dashboard"
          element={
            <ProtectedRoute allowedRoles={["organizer"]}>
              <OrganizerDashboard />
            </ProtectedRoute>
          }
        />
        <Route
          path="/organizer/events"
          element={
            <ProtectedRoute allowedRoles={["organizer"]}>
              <EventList />
            </ProtectedRoute>
          }
        />
        <Route
          path="/organizer/create-event"
          element={
            <ProtectedRoute allowedRoles={["organizer"]}>
              <CreateEvent />
            </ProtectedRoute>
          }
        />
        <Route
          path="/organizer/profile"
          element={
            <ProtectedRoute allowedRoles={["organizer"]}>
              <OrganizerProfile />
            </ProtectedRoute>
          }
        />
        <Route
          path="/organizer/edit-event/:eventId"
          element={
            <ProtectedRoute allowedRoles={["organizer"]}>
              <EditEvent />
            </ProtectedRoute>
          }
        />
        {/* Attendee Dashboard */}
        <Route
          path="/attendee-dashboard"
          element={
            <ProtectedRoute allowedRoles={["attendee"]}>
              <AttendeeDashboard />
            </ProtectedRoute>
          }
        />
      </Routes>
    </Router>
  );
}

export default App;
