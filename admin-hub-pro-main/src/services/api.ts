import axios from "axios";

const API = axios.create({
  baseURL: "http://72.60.205.49:5000/api",
});

export default API;
