const mongoose = require("mongoose");

const profileSchema = new mongoose.Schema(
  {
    mobile: {
      type: String,
      required: true,
      unique: true,
    },
    businessName: String,
    gst: String,
    businessType: String,
    category: String,
    address: String,
    email: String,
    about: String,
    contactPerson: String,
    logo: String,
  },
  { timestamps: true },
);

module.exports = mongoose.model("Profile", profileSchema);
