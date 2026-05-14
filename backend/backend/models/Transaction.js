const mongoose = require("mongoose");

const transactionSchema = new mongoose.Schema(
  {
    ownerMobile: String,
    customerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Customer",
    },
    type: String,
    amount: Number,
    note: String,
  },
  { timestamps: true },
);

module.exports = mongoose.model("Transaction", transactionSchema);
