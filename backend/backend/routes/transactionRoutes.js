// const express = require("express");
// const router = express.Router();

// const {
//   addTransaction,
//   getCustomerTransactions,
// } = require("../controllers/transactionController");

// router.post("/add", addTransaction);
// router.get("/:customerId", getCustomerTransactions);

// module.exports = router;
const express = require("express");
const router = express.Router();

const {
  addTransaction,
  getCustomerTransactions,
  getTransactionsByDateRange,
  getAllTransactionsByDateRange, // ✅ NEW
} = require("../controllers/transactionController");

// ================= EXISTING =================

router.post("/add", addTransaction);

// ✅ Single customer filter
router.post("/by-date", getTransactionsByDateRange);

// ✅ 🔥 ALL customers statement (IMPORTANT)
router.post("/all-by-date", getAllTransactionsByDateRange);

// 👇 ye hamesha last me (dynamic route)
router.get("/:customerId", getCustomerTransactions);

module.exports = router;
