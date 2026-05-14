const express = require("express");
const router = express.Router();
const Supplier = require("../models/Supplier");

router.post("/", async (req, res) => {
  const supplier = new Supplier(req.body);
  await supplier.save();
  res.json(supplier);
});

router.get("/", async (req, res) => {
  const suppliers = await Supplier.find();
  res.json(suppliers);
});

module.exports = router;
