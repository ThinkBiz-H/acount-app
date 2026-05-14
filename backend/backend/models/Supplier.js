const mongoose = require("mongoose");

const supplierSchema = new mongoose.Schema(
  {
    name: String,
    mobile: String,
    address: String,
  },
  { timestamps: true },
);

module.exports = mongoose.model("Supplier", supplierSchema);
