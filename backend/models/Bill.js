
const mongoose = require("mongoose");

const billSchema = new mongoose.Schema({

  ownerMobile: String,

  customerName: String,
  mobile: String,
  address: String,

  billNumber: String,
  date: Date,

  items: [
    {
      productCode: String,
      name: String,
      qty: Number,
      rate: Number,
      total: Number
    }
  ],

  subTotal: Number,
  gstTotal: Number,
  cessTotal: Number,

  charges: Number,
  discount: Number,

  grandTotal: Number,

  paid: {
    type: Boolean,
    default: false
  }

}, { timestamps: true });

module.exports = mongoose.model("Bill", billSchema);