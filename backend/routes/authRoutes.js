// const express = require("express");
// const router = express.Router();

// const { sendOtp, verifyOtp } = require("../controllers/authController");
// const { activatePlan } = require("../controllers/subscriptionController");
// router.post("/send-otp", sendOtp);
// router.post("/verify-otp", verifyOtp);

// router.post("/activate-plan", activatePlan);
// module.exports = router;

const express = require("express");
const router = express.Router();

const {
  sendOtp,
  verifyOtp,
  activatePlan,
} = require("../controllers/authController");

router.post("/send-otp", sendOtp);
router.post("/verify-otp", verifyOtp);
router.post("/activate-plan", activatePlan);

module.exports = router;
