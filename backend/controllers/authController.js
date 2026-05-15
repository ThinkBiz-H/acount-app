// const User = require("../models/User");
// const Device = require("../models/Device");

// // ================= SEND OTP =================

// exports.sendOtp = async (req, res) => {
//   try {
//     const { mobile } = req.body;

//     if (!mobile) {
//       return res.json({
//         success: false,
//         message: "Mobile number required",
//       });
//     }

//     let user = await User.findOne({ mobile });

//     if (!user) {
//       user = new User({ mobile });
//     }

//     const otp = Math.floor(100000 + Math.random() * 900000);

//     user.otp = otp;
//     user.otpExpiry = Date.now() + 5 * 60 * 1000;
//     if (!user.subscription) {
//       user.subscription = {
//         plan: "free",
//         isActive: true, // free bhi active hoga
//         startDate: new Date(),
//         endDate: new Date(new Date().setDate(new Date().getDate() + 7)), // 7 days free trial
//         dailyLimit: 2, // free limit
//       };
//     }
//     await user.save();

//     console.log("OTP:", otp);

//     res.json({
//       success: true,
//       message: "OTP generated (TEST MODE)",
//       mobile,
//       otp,
//     });
//   } catch (error) {
//     console.log("SEND OTP ERROR:", error);

//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

// // ================= VERIFY OTP =================

// // exports.verifyOtp = async (req, res) => {
// //   try {
// //     let { mobile, otp, deviceName } = req.body;

// //     console.log("VERIFY OTP REQUEST");

// //     if (!mobile || !otp) {
// //       return res.json({
// //         success: false,
// //         message: "Mobile and OTP required",
// //       });
// //     }

// //     const user = await User.findOne({ mobile });

// //     if (!user) {
// //       return res.json({
// //         success: false,
// //         message: "User not found",
// //       });
// //     }

// //     if (user.otp !== Number(otp)) {
// //       return res.json({
// //         success: false,
// //         message: "Invalid OTP",
// //       });
// //     }

// //     if (user.otpExpiry < Date.now()) {
// //       return res.json({
// //         success: false,
// //         message: "OTP expired",
// //       });
// //     }

// //     /// 🔥 DEFAULT DEVICE NAME
// //     if (!deviceName) {
// //       deviceName = "Android Device";
// //     }

// //     /// 🔥 FIX: REMOVE deviceId COMPLETELY (NO DUPLICATE ERROR)
// //     await Device.updateMany({ mobile }, { isCurrent: false });

// //     await Device.findOneAndUpdate(
// //       { mobile }, // ✅ ONLY MOBILE
// //       {
// //         mobile,
// //         deviceName,
// //         isCurrent: true,
// //         lastActive: new Date(),
// //       },
// //       // { upsert: true, new: true },
// //       { upsert: true, returnDocument: "after" },
// //     );

// //     console.log("DEVICE SAVED ✅");

// //     user.otp = null;
// //     user.otpExpiry = null;

// //     await user.save();

// //     res.json({
// //       success: true,
// //       message: "Login successful",
// //       user,
// //     });
// //   } catch (error) {
// //     console.log("OTP VERIFY ERROR:", error);

// //     res.status(500).json({
// //       success: false,
// //       message: error.message,
// //     });
// //   }
// // };

// exports.verifyOtp = async (req, res) => {
//   try {
//     let { mobile, otp, deviceName, deviceId } = req.body;

//     if (!mobile || !otp) {
//       return res.json({
//         success: false,
//         message: "Mobile and OTP required",
//       });
//     }

//     if (!deviceId) {
//       return res.json({
//         success: false,
//         message: "Device ID required",
//       });
//     }

//     const user = await User.findOne({ mobile });

//     if (!user) {
//       return res.json({
//         success: false,
//         message: "User not found",
//       });
//     }

//     if (user.otp !== Number(otp)) {
//       return res.json({
//         success: false,
//         message: "Invalid OTP",
//       });
//     }

//     if (user.otpExpiry < Date.now()) {
//       return res.json({
//         success: false,
//         message: "OTP expired",
//       });
//     }

//     if (!deviceName) {
//       deviceName = "Android Device";
//     }

//     // ✅ important
//     await Device.updateMany({ mobile }, { isCurrent: false });

//     await Device.findOneAndUpdate(
//       { mobile, deviceId }, // ✅ FIX
//       {
//         mobile,
//         deviceName,
//         deviceId,
//         isCurrent: true,
//         lastActive: new Date(),
//       },
//       { upsert: true, new: true },
//     );

//     user.otp = null;
//     user.otpExpiry = null;

//     await user.save();

//     res.json({
//       success: true,
//       message: "Login successful",
//       user,
//     });
//   } catch (error) {
//     console.log("OTP VERIFY ERROR:", error);

//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

// // ================= LOGOUT =================

// exports.logoutAllDevices = async (req, res) => {
//   try {
//     const { mobile } = req.body;

//     if (!mobile) {
//       return res.json({
//         success: false,
//         message: "Mobile required",
//       });
//     }

//     await Device.deleteMany({ mobile });

//     res.json({
//       success: true,
//       message: "All devices logged out",
//     });
//   } catch (error) {
//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

/// try aaj ka hai

const User = require("../models/User");
const Device = require("../models/Device");
const axios = require("axios");

// ================= SEND OTP =================

// exports.sendOtp = async (req, res) => {
//   try {
//     const { mobile } = req.body;

//     if (!mobile) {
//       return res.json({
//         success: false,
//         message: "Mobile number required",
//       });
//     }

//     let user = await User.findOne({ mobile });

//     if (!user) {
//       user = new User({ mobile });
//     }

//     const otp = Math.floor(100000 + Math.random() * 900000);

//     user.otp = otp;
//     user.otpExpiry = Date.now() + 5 * 60 * 1000;

//     // ✅ FREE USER DEFAULT SET
//     if (!user.subscription) {
//       user.subscription = {
//         plan: "free",
//         isActive: false, // ❌ free ≠ paid
//         startDate: null,
//         endDate: null,
//         dailyLimit: 5, // 🔥 FREE = 5 bills/day
//       };
//     }

//     await user.save();

//     console.log("OTP:", otp);

//     res.json({
//       success: true,
//       message: "OTP generated (TEST MODE)",
//       mobile,
//       otp,
//     });
//   } catch (error) {
//     console.log("SEND OTP ERROR:", error);

//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };
exports.sendOtp = async (req, res) => {
  try {
    const { mobile } = req.body;

    if (!mobile) {
      return res.json({
        success: false,
        message: "Mobile number required",
      });
    }

    let user = await User.findOne({ mobile });

    if (!user) {
      user = new User({ mobile });
    }

    // Generate OTP
    const otp = Math.floor(100000 + Math.random() * 900000);

    user.otp = otp;
    user.otpExpiry = Date.now() + 10 * 60 * 1000;

    // Free plan default
    if (!user.subscription) {
      user.subscription = {
        plan: "free",
        isActive: false,
        startDate: null,
        endDate: null,
        dailyLimit: 5,
      };
    }

    await user.save();

    console.log("Generated OTP:", otp);

    // Clean mobile (no +91)
    const cleanMobile = mobile.replace(/\D/g, "");
    console.log("Final Mobile:", cleanMobile);

    // Exact approved template text
    const message = encodeURIComponent(
      `Your SmartBahi login OTP is ${otp}. It is valid for 2 minutes. Please do not share this OTP with anyone.`,
    );

    // AmazeSMS URL
    const smsUrl =
      `https://api.amazesms.com/api/sms` +
      `?key=zcUevq9g` +
      `&from=SMTBHI` +
      `&to=${cleanMobile}` +
      `&body=${message}` +
      `&templateid=1007063382358607342` +
      `&entityid=1001296468739316118`;

    console.log("SMS URL:", smsUrl);

    const smsResponse = await axios.get(smsUrl);

    console.log("SMS RESPONSE:", smsResponse.data);

    // Success handling
    if (
      smsResponse.data.status === "success" ||
      smsResponse.data.description?.toLowerCase().includes("tracking id")
    ) {
      return res.json({
        success: true,
        message: "OTP sent successfully",
        mobile,
      });
    }

    return res.json({
      success: false,
      message: smsResponse.data.description || "SMS sending failed",
    });
  } catch (error) {
    console.log("SEND OTP ERROR:", error.response?.data || error.message);

    return res.status(500).json({
      success: false,
      message: error.response?.data?.description || error.message,
    });
  }
};
// ================= VERIFY OTP =================

// exports.verifyOtp = async (req, res) => {
//   try {
//     let { mobile, otp, deviceName, deviceId } = req.body;

//     if (!mobile || !otp) {
//       return res.json({
//         success: false,
//         message: "Mobile and OTP required",
//       });
//     }

//     if (!deviceId) {
//       return res.json({
//         success: false,
//         message: "Device ID required",
//       });
//     }

//     const user = await User.findOne({ mobile });

//     if (!user) {
//       return res.json({
//         success: false,
//         message: "User not found",
//       });
//     }

//     if (user.otp !== Number(otp)) {
//       return res.json({
//         success: false,
//         message: "Invalid OTP",
//       });
//     }

//     if (user.otpExpiry < Date.now()) {
//       return res.json({
//         success: false,
//         message: "OTP expired",
//       });
//     }

//     if (!deviceName) {
//       deviceName = "Android Device";
//     }

//     // ✅ mark all old devices inactive
//     await Device.updateMany({ mobile }, { isCurrent: false });

//     // ✅ save/update current device
//     await Device.findOneAndUpdate(
//       { mobile, deviceId },
//       {
//         mobile,
//         deviceName,
//         deviceId,
//         isCurrent: true,
//         lastActive: new Date(),
//       },
//       { upsert: true, new: true },
//     );

//     // ✅ clear OTP
//     user.otp = null;
//     user.otpExpiry = null;

//     await user.save();

//     res.json({
//       success: true,
//       message: "Login successful",
//       user,
//     });
//   } catch (error) {
//     console.log("OTP VERIFY ERROR:", error);

//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

exports.verifyOtp = async (req, res) => {
  try {
    console.log("VERIFY BODY:", req.body);

    let { mobile, otp, deviceName, deviceId } = req.body;

    if (!mobile || !otp) {
      return res.json({
        success: false,
        message: "Mobile and OTP required",
      });
    }

    if (!deviceId) {
      return res.json({
        success: false,
        message: "Device ID required",
      });
    }

    const user = await User.findOne({ mobile });

    if (!user) {
      return res.json({
        success: false,
        message: "User not found",
      });
    }

    console.log("DB OTP:", user.otp);
    console.log("Entered OTP:", otp);

    // safer comparison
    if (String(user.otp).trim() !== String(otp).trim()) {
      return res.json({
        success: false,
        message: "Invalid OTP",
      });
    }

    // expiry check
    if (!user.otpExpiry || user.otpExpiry < Date.now()) {
      return res.json({
        success: false,
        message: "OTP expired",
      });
    }

    if (!deviceName) {
      deviceName = "Android Device";
    }

    // mark old devices inactive
    await Device.updateMany({ mobile }, { isCurrent: false });

    // save current device
    await Device.findOneAndUpdate(
      { mobile, deviceId },
      {
        mobile,
        deviceName,
        deviceId,
        isCurrent: true,
        lastActive: new Date(),
      },
      {
        upsert: true,
        new: true,
      },
    );

    // clear otp after success
    user.otp = null;
    user.otpExpiry = null;

    await user.save();

    return res.json({
      success: true,
      message: "Login successful",
      user,
    });
  } catch (error) {
    console.log("OTP VERIFY ERROR:", error);

    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// ================= ACTIVATE PLAN =================

exports.activatePlan = async (req, res) => {
  try {
    const { mobile, plan, dailyLimit, days } = req.body;

    if (!mobile || !plan || !dailyLimit || !days) {
      return res.json({
        success: false,
        message: "All fields required",
      });
    }

    const startDate = new Date();
    const endDate = new Date();
    endDate.setDate(startDate.getDate() + days);

    const user = await User.findOneAndUpdate(
      { mobile },
      {
        subscription: {
          plan,
          dailyLimit,
          startDate,
          endDate,
          isActive: true,
        },
      },
      { new: true },
    );

    res.json({
      success: true,
      message: "Plan activated successfully 🚀",
      subscription: user.subscription,
    });
  } catch (err) {
    console.log("ACTIVATE PLAN ERROR:", err);

    res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};

// ================= LOGOUT ALL DEVICES =================

exports.logoutAllDevices = async (req, res) => {
  try {
    const { mobile } = req.body;

    if (!mobile) {
      return res.json({
        success: false,
        message: "Mobile required",
      });
    }

    await Device.deleteMany({ mobile });

    res.json({
      success: true,
      message: "All devices logged out",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
