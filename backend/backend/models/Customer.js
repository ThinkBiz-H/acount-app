// const mongoose = require("mongoose");

// const customerSchema = new mongoose.Schema({
//   ownerMobile: String,

//   name: String,
//   mobile: String,
//   address: String,
//   type: String, // ⭐ CUSTOMER / SUPPLIER
//   imageBase64: {
//     type: String,
//     default: "",
//   },
// });

// module.exports = mongoose.model("Customer", customerSchema);

const mongoose = require("mongoose");

const customerSchema = new mongoose.Schema({
  ownerMobile: String,

  name: String,
  mobile: String,
  address: String,
  type: String, // CUSTOMER / SUPPLIER

  imageBase64: {
    type: String,
    default: "",
  },

  /// 🔥 ADD THIS
  balance: {
    type: Number,
    default: 0,
  },
});

module.exports = mongoose.model("Customer", customerSchema);
