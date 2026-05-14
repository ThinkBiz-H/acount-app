

// const mongoose = require("mongoose");

// const deviceSchema = new mongoose.Schema(
//   {
//     mobile: {
//       type: String,
//       required: true,
//       index: true,
//     },
//     deviceName: {
//       type: String,
//       default: "Unknown Device",
//     },
//     deviceId: {
//       type: String,
//       required: true,
//     },
//     isCurrent: {
//       type: Boolean,
//       default: false,
//     },
//     location: {
//       type: String,
//       default: "India",
//     },
//     lastActive: {
//       type: Date,
//       default: Date.now,
//     },
//   },
//   { timestamps: true },
// );

// deviceSchema.index({ mobile: 1, deviceId: 1 }, { unique: true });

// module.exports = mongoose.model("Device", deviceSchema);


const mongoose = require("mongoose");

const deviceSchema = new mongoose.Schema(
  {
    mobile: {
      type: String,
      required: true,
      index: true,
    },
    deviceName: {
      type: String,
      default: "Unknown Device",
    },
    deviceId: {
      type: String,
      required: true,
    },
    isCurrent: {
      type: Boolean,
      default: false,
    },
    location: {
      type: String,
      default: "India",
    },
    lastActive: {
      type: Date,
      default: Date.now,
    },
  },
  { timestamps: true },
);

deviceSchema.index({ mobile: 1, deviceId: 1 }, { unique: true });

module.exports = mongoose.model("Device", deviceSchema);
