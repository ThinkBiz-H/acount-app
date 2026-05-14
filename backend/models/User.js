// const mongoose = require("mongoose");

// const userSchema = new mongoose.Schema(
//   {
//     mobile: {
//       type: String,
//       required: true,
//       unique: true,
//       trim: true,
//     },

//     otp: {
//       type: Number,
//     },

//     otpExpiry: {
//       type: Date,
//     },

//     // 🔥 SUBSCRIPTION ADD
//     subscription: {
//       plan: {
//         type: String,
//         default: "free",
//       },
//       startDate: {
//         type: Date,
//       },
//       endDate: {
//         type: Date,
//       },
//       isActive: {
//         type: Boolean,
//         default: false,
//       },
//       dailyLimit: {
//         type: Number,
//         default: 2, // free user ke liye
//       },
//     },
//     subscription: {
//       plan: { type: String, default: "free" },
//       startDate: Date,
//       endDate: Date,
//       dailyLimit: { type: Number, default: 2 },
//     },

//     status: {
//       type: String,
//       enum: ["Active", "Blocked"],
//       default: "Active",
//     },
//   },
//   {
//     timestamps: true,
//   },
// );

// module.exports = mongoose.model("User", userSchema);

const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    mobile: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },

    otp: Number,
    otpExpiry: Date,

    // ✅ FINAL SUBSCRIPTION SYSTEM
    subscription: {
      plan: {
        type: String,
        default: "free",
      },
      startDate: Date,
      endDate: Date,
      isActive: {
        type: Boolean,
        default: false,
      },
      dailyLimit: {
        type: Number,
        default: 5, // 🔥 FREE USER = 5/day
      },
    },

    status: {
      type: String,
      enum: ["Active", "Blocked"],
      default: "Active",
    },
  },
  { timestamps: true },
);

module.exports = mongoose.model("User", userSchema);
