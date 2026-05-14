const mongoose = require("mongoose");

const paymentSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
    userName: String,
    userMobile: String,

    amount: Number,
    plan: String,

    status: {
      type: String,
      enum: ["success", "failed"],
      default: "success",
    },

    date: {
      type: Date,
      default: Date.now,
    },
  },
  { timestamps: true },
);

module.exports = mongoose.model("Payment", paymentSchema);
