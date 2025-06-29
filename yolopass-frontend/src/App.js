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

// Organizer Components
import EventList from './organizer/EventList';
import CreateEvent from './organizer/CreateEvent';
import OrganizerProfile from './organizer/OrganizerProfile';
import EditEvent from './organizer/EditEvent';
import CreateDiscountCode from './organizer/CreateDiscountCode'

// Attendee Components
import AttendeeProfile from './attendee/AttendeeProfile';
import AttendeeEventDetails from './attendee/AttendeeEventDetails';
import RegistrationReview from './attendee/RegistrationReview';
import EventRegistration from "./attendee/EventRegistration";
import CartPage from "./attendee/CartPage";

// Homepage Component
import Homepage from './components/Homepage'; // Adjust the path if needed

//Admin Components
import VenueManagement from './admin/VenueManagement';
import ViewOrganizers from "./admin/ViewOrganizers";
import ViewEvents from "./admin/ViewEvents";
import ViewUsers from "./admin/ViewUsers";

function App() {
  return (
    <Router>
      <Routes>
        {/* Public Routes */}
        <Route path="/" element={<Homepage />} /> {/* Add Homepage Route */}
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
        <Route
          path="/admin/venues"
          element={
            <ProtectedRoute allowedRoles={["admin"]}>
              <VenueManagement />
            </ProtectedRoute>
          }
        />
        <Route
          path="/admin/organizers"
          element={
            <ProtectedRoute allowedRoles={["admin"]}>
              <ViewOrganizers />
            </ProtectedRoute>
          }
        />
        <Route
          path="/admin/events"
          element={
            <ProtectedRoute allowedRoles={["admin"]}>
              <ViewEvents />
            </ProtectedRoute>
          }
        />
        <Route
          path="/admin/users"
          element={
            <ProtectedRoute allowedRoles={["admin"]}>
              <ViewUsers />
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
        <Route
          path="/organizer/create-discount-code/:event_id"
          element={
            <ProtectedRoute allowedRoles={["organizer"]}>
              <CreateDiscountCode />
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
        <Route
          path="/attendee/register"
          element={
            <ProtectedRoute allowedRoles={["attendee"]}>
              <EventRegistration />
            </ProtectedRoute>
          }
        />
        <Route
          path="attendee/profile"
          element={
            <ProtectedRoute allowedRoles={["attendee"]}>
              <AttendeeProfile />
            </ProtectedRoute>
          }
        />
        <Route
          path="/attendee/events/:eventId"
          element={
            <ProtectedRoute allowedRoles={["attendee"]}>
              <AttendeeEventDetails />
            </ProtectedRoute>
          }
        />
        <Route
          path="/attendee/review/:registrationId" 
          element={
            <ProtectedRoute allowedRoles={["attendee"]}>
              <RegistrationReview />
            </ProtectedRoute>
          }
        />
        <Route
          path="/attendee/cart" 
          element={
            <ProtectedRoute allowedRoles={["attendee"]}>
              <CartPage />
            </ProtectedRoute>
          }
        />
      </Routes>
    </Router>
  );
}

export default App;
