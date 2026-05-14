// const express = require("express");
// const router = express.Router();

// const {
//   addProduct,
//   getProducts,
//   updateProduct,
//   deleteProduct,
// } = require("../controllers/productController");

// router.post("/", addProduct);

// router.get("/:mobile", getProducts);

// router.put("/:id", updateProduct);

// router.delete("/:id", deleteProduct);

// module.exports = router;const express = require("express");

// const express = require("express");
// const router = express.Router();

// const {
//   addProduct,
//   getProducts,
//   updateProduct,
//   deleteProduct,
// } = require("../controllers/productController");

// const {
//   sendChangeMobileOtp,
//   verifyChangeMobile,
// } = require("../controllers/profileController");

// // ================================
// // Change Mobile Number Routes
// // ================================

// router.post("/send-change-mobile-otp", sendChangeMobileOtp);

// router.post("/verify-change-mobile", verifyChangeMobile);

// // ================================
// // Product Routes
// // ================================

// router.post("/", addProduct);
// router.get("/:mobile", getProducts);
// router.put("/:id", updateProduct);
// router.delete("/:id", deleteProduct);

// module.exports = router;

const express = require("express");
const router = express.Router();

const {
  saveProfile,
  getProfile,
  sendChangeMobileOtp,
  verifyChangeMobile,
} = require("../controllers/profileController");

// ================= PROFILE =================

router.post("/", saveProfile);
router.get("/:mobile", getProfile);

// ================= CHANGE MOBILE =================

router.post("/send-change-mobile-otp", sendChangeMobileOtp);
router.post("/verify-change-mobile", verifyChangeMobile);

module.exports = router;
