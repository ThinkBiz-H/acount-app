import axios from "axios";

const API = axios.create({
  baseURL: "https://captivating-achievement-production-bcb2.up.railway.app/api",
});

export default API;
