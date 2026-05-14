// const express = require("express");
// const cors = require("cors");
// const dotenv = require("dotenv");
// const connectDB = require("./config/db");

// // Routes
// const authRoutes = require("./routes/authRoutes");
// const customerRoutes = require("./routes/customerRoutes");
// const supplierRoutes = require("./routes/supplierRoutes");
// const billRoutes = require("./routes/billRoutes");
// const reminderRoutes = require("./routes/reminderRoutes");
// const profileRoutes = require("./routes/profileRoutes");
// const productRoutes = require("./routes/productRoutes");
// const transactionRoutes = require("./routes/transactionRoutes");
// const deviceRoutes = require("./routes/deviceRoutes");
// const adminRoutes = require("./routes/adminRoutes");
// require("./services/reminderService");
// // Load env
// dotenv.config();

// // Connect DB
// connectDB();

// const app = express();

// // ================= MIDDLEWARE =================

// app.use(
//   cors({
//     origin: "*",
//     credentials: true,
//   }),
// );

// app.use(express.json());
// app.use(express.urlencoded({ extended: true }));

// // ================= ROUTES =================

// app.use("/api/devices", deviceRoutes);

// app.use("/api/auth", authRoutes);
// app.use("/api/customers", customerRoutes);
// app.use("/api/suppliers", supplierRoutes);
// app.use("/api/bills", billRoutes);
// app.use("/api/reminders", reminderRoutes);
// app.use("/api/profile", profileRoutes);
// app.use("/api/products", productRoutes);
// app.use("/api/transactions", transactionRoutes);
// app.use("/api/admin", adminRoutes);

// // ================= HEALTH CHECK =================

// app.get("/", (req, res) => {
//   res.send("🚀 Smart Bahi Backend Running");
// });

// app.get("/health", (req, res) => {
//   res.status(200).json({
//     status: "OK",
//     uptime: process.uptime(),
//     timestamp: new Date(),
//   });
// });

// // ================= 404 =================

// app.use((req, res) => {
//   res.status(404).json({
//     success: false,
//     message: "Route not found",
//   });
// });

// // ================= ERROR HANDLER =================

// app.use((err, req, res, next) => {
//   console.error(err);

//   res.status(err.status || 500).json({
//     success: false,
//     message: err.message || "Internal Server Error",
//   });
// });

// // ================= SERVER =================

// const PORT = process.env.PORT || 5000;

// const server = app.listen(PORT, () => {
//   console.log("=================================");
//   console.log("🚀 Smart Bahi Backend Started");
//   console.log(`🌍 Environment : ${process.env.NODE_ENV || "development"}`);
//   console.log(`🔌 Port        : ${PORT}`);
//   console.log("=================================");
// });

// // ================= GRACEFUL SHUTDOWN =================

// const shutdown = (signal) => {
//   console.log(`\n⚠️ ${signal} received. Shutting down...`);

//   server.close(() => {
//     console.log("✅ Server closed");
//     process.exit(0);
//   });
// };

// process.on("SIGINT", shutdown);
// process.on("SIGTERM", shutdown);

// process.on("uncaughtException", (err) => {
//   console.error("❌ Uncaught Exception:", err);
// });

// process.on("unhandledRejection", (err) => {
//   console.error("❌ Unhandled Rejection:", err);
// });
//
const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const connectDB = require("./config/db");

// Routes
const authRoutes = require("./routes/authRoutes");
const customerRoutes = require("./routes/customerRoutes");
const supplierRoutes = require("./routes/supplierRoutes");
const billRoutes = require("./routes/billRoutes");
const reminderRoutes = require("./routes/reminderRoutes");
const profileRoutes = require("./routes/profileRoutes");
const productRoutes = require("./routes/productRoutes");
const transactionRoutes = require("./routes/transactionRoutes");
const deviceRoutes = require("./routes/deviceRoutes");
const adminRoutes = require("./routes/adminRoutes");

require("./services/reminderService");

// Load env
dotenv.config();

// Connect DB
connectDB();

const app = express();

// ================= 🔥 FINAL CORS FIX =================

// ✅ allow all origins (safe for now)
app.use(
  cors({
    origin: true,
    credentials: true,
  }),
);

// ✅ HANDLE ALL PREFLIGHT REQUESTS (IMPORTANT)

// ================= MIDDLEWARE =================

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ================= ROUTES =================

app.use("/api/devices", deviceRoutes);

app.use("/api/auth", authRoutes);
app.use("/api/customers", customerRoutes);
app.use("/api/suppliers", supplierRoutes);
app.use("/api/bills", billRoutes);
app.use("/api/reminders", reminderRoutes);
app.use("/api/profile", profileRoutes);
app.use("/api/products", productRoutes);
app.use("/api/transactions", transactionRoutes);
app.use("/api/admin", adminRoutes);

// ================= HEALTH CHECK =================

app.get("/", (req, res) => {
  res.send("🚀 Smart Bahi Backend Running");
});

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "OK",
    uptime: process.uptime(),
    timestamp: new Date(),
  });
});

// ================= 404 =================

app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: "Route not found",
  });
});

// ================= ERROR HANDLER =================

app.use((err, req, res, next) => {
  console.error("❌ Error:", err);

  res.status(err.status || 500).json({
    success: false,
    message: err.message || "Internal Server Error",
  });
});

// ================= SERVER =================

const PORT = process.env.PORT || 5000;

const server = app.listen(PORT, () => {
  console.log("=================================");
  console.log("🚀 Smart Bahi Backend Started");
  console.log(`🌍 Environment : ${process.env.NODE_ENV || "development"}`);
  console.log(`🔌 Port        : ${PORT}`);
  console.log("=================================");
});

// ================= GRACEFUL SHUTDOWN =================

const shutdown = (signal) => {
  console.log(`\n⚠️ ${signal} received. Shutting down...`);

  server.close(() => {
    console.log("✅ Server closed");
    process.exit(0);
  });
};

process.on("SIGINT", shutdown);
process.on("SIGTERM", shutdown);

process.on("uncaughtException", (err) => {
  console.error("❌ Uncaught Exception:", err);
});

process.on("unhandledRejection", (err) => {
  console.error("❌ Unhandled Rejection:", err);
});
