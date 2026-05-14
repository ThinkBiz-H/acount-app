// const mongoose = require("mongoose");

// const productSchema = new mongoose.Schema(
//   {
//     mobile: String,

//     name: String,
//     mrp: Number,
//     qty: Number,
//     unit: String,
//     rate: Number,
//     date: String,
//     tax: String,
//     taxType: String,
//     productCode: String,
//     imagePath: String,
//   },
//   { timestamps: true },
// );

// module.exports = mongoose.model("Product", productSchema);

const mongoose = require("mongoose");

const productSchema = new mongoose.Schema(
  {
    mobile: String,

    name: String,
    mrp: Number,
    qty: Number,
    unit: String,
    rate: Number,
    date: String,
    tax: String,
    taxType: String,

    /// 🔥 FIXED
    productCode: {
      type: String,
      required: true,
      unique: true,
    },

    imagePath: String,
  },
  { timestamps: true },
);

module.exports = mongoose.model("Product", productSchema);
