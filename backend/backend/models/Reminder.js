// const mongoose = require("mongoose");

// const reminderSchema = new mongoose.Schema(
//   {
//     ownerMobile: {
//       type: String,
//       required: true,
//     },

//     customerId: {
//       type: mongoose.Schema.Types.ObjectId,
//       ref: "Customer",
//     },

//     message: {
//       type: String,
//       default: "",
//     },

//     date: {
//       type: Date,
//       required: true,
//     },
//   },
//   {
//     timestamps: true,
//   },
// );

// module.exports = mongoose.model("Reminder", reminderSchema);

const mongoose = require("mongoose");

const reminderSchema = new mongoose.Schema(
  {
    ownerMobile: {
      type: String,
      required: true,
    },

    customerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Customer",
      required: true,
    },

    customerName: {
      type: String,
    },

    mobile: {
      type: String,
    },

    amount: {
      type: Number,
      default: 0,
    },

    message: {
      type: String,
      default: "",
    },

    date: {
      type: Date,
      required: true,
    },

    sent: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  },
);

module.exports = mongoose.model("Reminder", reminderSchema);
