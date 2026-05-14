// const Profile = require("../models/Profile");
// const Customer = require("../models/Customer");
// const Supplier = require("../models/Supplier");
// const Product = require("../models/Product");
// const Bill = require("../models/Bill");
// const Transaction = require("../models/Transaction");
// const Reminder = require("../models/Reminder");

// let otpStore = {};

// // =======================
// // SAVE PROFILE
// // =======================

// exports.saveProfile = async (req, res) => {
//   try {
//     const { mobile } = req.body;

//     let profile = await Profile.findOne({ mobile });

//     if (!profile) {
//       profile = new Profile(req.body);
//     } else {
//       Object.assign(profile, req.body);
//     }

//     await profile.save();

//     res.json({
//       success: true,
//       data: profile,
//     });
//   } catch (error) {
//     res.json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

// // =======================
// // GET PROFILE
// // =======================

// exports.getProfile = async (req, res) => {
//   try {
//     const { mobile } = req.params;

//     const profile = await Profile.findOne({ mobile });

//     res.json({
//       success: true,
//       data: profile,
//     });
//   } catch (error) {
//     res.json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

// // =======================
// // SEND OTP CHANGE MOBILE
// // =======================

// exports.sendChangeMobileOtp = async (req, res) => {
//   try {
//     const { oldMobile, newMobile } = req.body;

//     const existing = await Profile.findOne({ mobile: newMobile });

//     if (existing) {
//       return res.json({
//         success: false,
//         message: "Mobile already registered",
//       });
//     }

//     const otp = Math.floor(1000 + Math.random() * 9000);

//     otpStore[newMobile] = {
//       otp,
//       oldMobile,
//     };

//     console.log("=================================");
//     console.log("📱 CHANGE MOBILE OTP");
//     console.log("New Mobile:", newMobile);
//     console.log("OTP:", otp);
//     console.log("=================================");

//     res.json({
//       success: true,
//       message: "OTP generated (check terminal)",
//     });
//   } catch (error) {
//     res.json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

// // =======================
// // VERIFY OTP + TRANSFER DATA
// // =======================

// exports.verifyChangeMobile = async (req, res) => {
//   try {
//     const { newMobile, otp } = req.body;

//     const data = otpStore[newMobile];

//     if (!data) {
//       return res.json({
//         success: false,
//         message: "OTP expired",
//       });
//     }

//     if (data.otp != otp) {
//       return res.json({
//         success: false,
//         message: "Invalid OTP",
//       });
//     }

//     const oldMobile = data.oldMobile;

//     // PROFILE
//     await Profile.updateMany(
//       { mobile: oldMobile },
//       { $set: { mobile: newMobile } },
//     );

//     // CUSTOMERS
//     await Customer.updateMany(
//       { ownerMobile: oldMobile },
//       { $set: { ownerMobile: newMobile } },
//     );

//     // SUPPLIERS
//     await Supplier.updateMany(
//       { ownerMobile: oldMobile },
//       { $set: { ownerMobile: newMobile } },
//     );

//     // PRODUCTS
//     await Product.updateMany(
//       { mobile: oldMobile },
//       { $set: { mobile: newMobile } },
//     );

//     // BILLS
//     await Bill.updateMany(
//       { ownerMobile: oldMobile },
//       { $set: { ownerMobile: newMobile } },
//     );

//     // TRANSACTIONS
//     await Transaction.updateMany(
//       { ownerMobile: oldMobile },
//       { $set: { ownerMobile: newMobile } },
//     );

//     // REMINDERS
//     await Reminder.updateMany(
//       { ownerMobile: oldMobile },
//       { $set: { ownerMobile: newMobile } },
//     );

//     delete otpStore[newMobile];

//     res.json({
//       success: true,
//       message: "Mobile updated and all data transferred successfully",
//     });
//   } catch (error) {
//     res.json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

const Profile = require("../models/Profile");
const Customer = require("../models/Customer");
const Supplier = require("../models/Supplier");
const Product = require("../models/Product");
const Bill = require("../models/Bill");
const Transaction = require("../models/Transaction");
const Reminder = require("../models/Reminder");

let otpStore = {};

// =======================
// SAVE PROFILE
// =======================

exports.saveProfile = async (req, res) => {
  try {
    const { mobile } = req.body;

    let profile = await Profile.findOne({ mobile });

    if (!profile) {
      profile = new Profile(req.body);
    } else {
      Object.assign(profile, req.body);
    }

    await profile.save();

    res.json({
      success: true,
      data: profile,
    });
  } catch (error) {
    res.json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// GET PROFILE
// =======================

exports.getProfile = async (req, res) => {
  try {
    const { mobile } = req.params;

    const profile = await Profile.findOne({ mobile });

    res.json({
      success: true,
      data: profile,
    });
  } catch (error) {
    res.json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// SEND OTP CHANGE MOBILE
// =======================

exports.sendChangeMobileOtp = async (req, res) => {
  try {
    const { oldMobile, newMobile } = req.body;

    const existing = await Profile.findOne({ mobile: newMobile });

    if (existing) {
      return res.json({
        success: false,
        message: "Mobile already registered",
      });
    }

    // OTP spam protection
    const existingOtp = otpStore[newMobile];

    if (existingOtp && Date.now() < existingOtp.expires - 240000) {
      return res.json({
        success: false,
        message: "Please wait before requesting another OTP",
      });
    }

    const otp = Math.floor(1000 + Math.random() * 9000);

    otpStore[newMobile] = {
      otp,
      oldMobile,
      expires: Date.now() + 2 * 60 * 1000,
    };

    // Only show OTP in development
    if (process.env.NODE_ENV !== "production") {
      console.log("=================================");
      console.log("📱 CHANGE MOBILE OTP");
      console.log("New Mobile:", newMobile);
      console.log("OTP:", otp);
      console.log("=================================");
    }

    res.json({
      success: true,
      message: "OTP generated (check terminal)",
    });
  } catch (error) {
    res.json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// VERIFY OTP + TRANSFER DATA
// =======================

exports.verifyChangeMobile = async (req, res) => {
  try {
    const { newMobile, otp } = req.body;

    const data = otpStore[newMobile];

    if (!data) {
      return res.json({
        success: false,
        message: "OTP expired",
      });
    }

    // OTP expiry check
    if (Date.now() > data.expires) {
      delete otpStore[newMobile];

      return res.json({
        success: false,
        message: "OTP expired",
      });
    }

    if (data.otp != otp) {
      return res.json({
        success: false,
        message: "Invalid OTP",
      });
    }

    const oldMobile = data.oldMobile;

    // PROFILE
    await Profile.updateMany(
      { mobile: oldMobile },
      { $set: { mobile: newMobile } },
    );

    // CUSTOMERS
    await Customer.updateMany(
      { ownerMobile: oldMobile },
      { $set: { ownerMobile: newMobile } },
    );

    // SUPPLIERS
    await Supplier.updateMany(
      { ownerMobile: oldMobile },
      { $set: { ownerMobile: newMobile } },
    );

    // PRODUCTS
    await Product.updateMany(
      { mobile: oldMobile },
      { $set: { mobile: newMobile } },
    );

    // BILLS
    await Bill.updateMany(
      { ownerMobile: oldMobile },
      { $set: { ownerMobile: newMobile } },
    );

    // TRANSACTIONS
    await Transaction.updateMany(
      { ownerMobile: oldMobile },
      { $set: { ownerMobile: newMobile } },
    );

    // REMINDERS
    await Reminder.updateMany(
      { ownerMobile: oldMobile },
      { $set: { ownerMobile: newMobile } },
    );

    delete otpStore[newMobile];

    res.json({
      success: true,
      message: "Mobile updated and all data transferred successfully",
    });
  } catch (error) {
    res.json({
      success: false,
      message: error.message,
    });
  }
};
