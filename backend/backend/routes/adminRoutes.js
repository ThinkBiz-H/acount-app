const express = require("express");
const router = express.Router();

const {
  getUsers,
  getUser,
  updatePlan,
  toggleUserStatus,
  getDashboard,
  getPayments,
  getAnalytics,
  getSettings,
  updateSettings,
} = require("../controllers/adminController");

/// ================= USERS =================
router.get("/users", getUsers);
router.get("/user/:id", getUser);

/// ================= USER CONTROL =================
router.post("/update-plan", updatePlan);
router.post("/toggle-user-status", toggleUserStatus);

/// ================= DASHBOARD =================
router.get("/dashboard", getDashboard);
router.get("/payments", getPayments);
router.get("/analytics", getAnalytics);

/// ================= SETTINGS (🔥 MAIN FEATURE) =================
router.get("/settings", getSettings);
router.post("/settings/update", updateSettings);
router.post("/login", (req, res) => {
  const { email, password } = req.body;

  if (email === "admin@admin.com" && password === "admin123") {
    return res.json({
      success: true,
      token: "admin-token",
      admin: { email },
    });
  }

  return res.status(401).json({
    success: false,
    message: "Invalid credentials",
  });
});
module.exports = router;
