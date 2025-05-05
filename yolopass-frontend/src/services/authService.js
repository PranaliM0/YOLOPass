// services/authService.js

export const setToken = (token) => {
  localStorage.setItem("token", token);
};

export const getToken = () => {
  return localStorage.getItem("token");
};

export const removeToken = () => {
  localStorage.removeItem("token");
  localStorage.removeItem("role");
};
  
  export const isAuthenticated = () => {
    const token = getToken();
    return !!token;
  };
  