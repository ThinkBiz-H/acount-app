// const express = require("express");
// const router = express.Router();

// const {
//   createBill,
//   getBills,
//   deleteBill,
// } = require("../controllers/billController");

// router.post("/", createBill);

// router.get("/:mobile", getBills);

// router.delete("/:id", deleteBill);

// module.exports = router;




const express = require("express");
const router = express.Router();

const billController = require("../controllers/billController");

router.post("/", billController.addBill);

router.get("/:mobile", billController.getBills);

router.put("/:id", billController.updateBill);

router.delete("/:id", billController.deleteBill);

module.exports = router;
