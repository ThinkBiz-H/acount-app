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

// module.exports = router;

const express = require("express");
const router = express.Router();

const {
  addProduct,
  getProducts,
  updateProduct,
  deleteProduct,
} = require("../controllers/productController");

/// ADD
router.post("/", addProduct);

/// GET
router.get("/:mobile", getProducts);

/// 🔥 UPDATE (IMPORTANT FIX)
router.put("/update/:code", updateProduct);

/// DELETE
router.delete("/:id", deleteProduct);

module.exports = router;
