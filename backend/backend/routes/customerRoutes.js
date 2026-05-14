const express = require("express");
const router = express.Router();

const customerController = require("../controllers/customerController");

// Add customer
router.post("/", customerController.addCustomer);

// Get customers by owner mobile
router.get("/:mobile", customerController.getCustomers);

// Update customer
router.put("/:id", customerController.updateCustomer);
router.delete("/:id", customerController.deleteCustomer);
module.exports = router;
