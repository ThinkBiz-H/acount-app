// const User = require("../models/User");
// const Bill = require("../models/Bill");

// /// 👥 ALL USERS
// exports.getUsers = async (req, res) => {
//   const users = await User.find().sort({ createdAt: -1 });

//   res.json({
//     success: true,
//     data: users,
//   });
// };

// /// 👤 SINGLE USER
// exports.getUser = async (req, res) => {
//   const user = await User.findById(req.params.id);

//   res.json({
//     success: true,
//     data: user,
//   });
// };

// /// 🔥 UPDATE PLAN
// exports.updatePlan = async (req, res) => {
//   const { userId, plan, days, dailyLimit } = req.body;

//   const user = await User.findById(userId);

//   if (!user) {
//     return res.json({ success: false, message: "User not found" });
//   }

//   const now = new Date();
//   const end = user.subscription?.endDate || now;

//   const newEnd = new Date(end);
//   newEnd.setDate(newEnd.getDate() + Number(days));

//   user.subscription = {
//     plan,
//     startDate: user.subscription?.startDate || now,
//     endDate: newEnd,
//     dailyLimit,
//   };

//   await user.save();

//   res.json({ success: true });
// };

// /// 🔒 BLOCK / UNBLOCK
// exports.toggleUserStatus = async (req, res) => {
//   const { userId } = req.body;

//   const user = await User.findById(userId);

//   user.status = user.status === "Active" ? "Blocked" : "Active";

//   await user.save();

//   res.json({ success: true });
// };

// /// 📊 DASHBOARD
// exports.getDashboard = async (req, res) => {
//   const totalUsers = await User.countDocuments();
//   const activeSubscriptions = await User.countDocuments({
//     "subscription.plan": { $ne: "free" },
//   });

//   const totalBills = await Bill.countDocuments();

//   res.json({
//     success: true,
//     data: {
//       totalUsers,
//       activeSubscriptions,
//       totalBills,
//       todayRevenue: 0,
//       userGrowth: [],
//       dailyBills: [],
//       recentActivity: [],
//     },
//   });
// };

// /// 💳 PAYMENTS (dummy for now)
// exports.getPayments = async (req, res) => {
//   res.json({
//     success: true,
//     data: [],
//   });
// };

// exports.getAnalytics = async (req, res) => {
//   try {
//     const User = require("../models/User");
//     const Bill = require("../models/Bill");

//     /// ================= USER GROWTH (MONTH WISE) =================
//     const users = await User.aggregate([
//       {
//         $group: {
//           _id: { $month: "$createdAt" },
//           users: { $sum: 1 },
//         },
//       },
//       { $sort: { _id: 1 } },
//     ]);

//     const months = [
//       "Jan",
//       "Feb",
//       "Mar",
//       "Apr",
//       "May",
//       "Jun",
//       "Jul",
//       "Aug",
//       "Sep",
//       "Oct",
//       "Nov",
//       "Dec",
//     ];

//     const userGrowth = users.map((u) => ({
//       month: months[u._id - 1],
//       users: u.users,
//     }));

//     /// ================= DAILY BILLS (LAST 7 DAYS) =================
//     const last7Days = await Bill.aggregate([
//       {
//         $match: {
//           createdAt: {
//             $gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
//           },
//         },
//       },
//       {
//         $group: {
//           _id: { $dayOfWeek: "$createdAt" },
//           bills: { $sum: 1 },
//         },
//       },
//       { $sort: { _id: 1 } },
//     ]);

//     const daysMap = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

//     const dailyBills = last7Days.map((d) => ({
//       day: daysMap[d._id - 1],
//       bills: d.bills,
//     }));

//     /// ================= RESPONSE =================
//     res.json({
//       success: true,
//       data: {
//         userGrowth,
//         dailyBills,
//       },
//     });
//   } catch (e) {
//     console.log("Analytics Error:", e);
//     res.status(500).json({
//       success: false,
//       message: e.message,
//     });
//   }
// };

const User = require("../models/User");
const Bill = require("../models/Bill");
const AppSettings = require("../models/AppSettings"); // 🔥 NEW
const Payment = require("../models/Payment");
/// 👥 ALL USERS
exports.getUsers = async (req, res) => {
  try {
    const users = await User.find().sort({ createdAt: -1 });

    res.json({
      success: true,
      data: users,
    });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};

/// 👤 SINGLE USER
exports.getUser = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);

    res.json({
      success: true,
      data: user,
    });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};

/// 🔥 UPDATE PLAN (ADMIN MANUAL)
exports.updatePlan = async (req, res) => {
  try {
    const { userId, plan, days, dailyLimit } = req.body;

    const user = await User.findById(userId);

    if (!user) {
      return res.json({ success: false, message: "User not found" });
    }

    const now = new Date();
    const end = user.subscription?.endDate || now;

    const newEnd = new Date(end);
    newEnd.setDate(newEnd.getDate() + Number(days));

    user.subscription = {
      plan,
      startDate: user.subscription?.startDate || now,
      endDate: newEnd,
      dailyLimit,
      isActive: true, // 🔥 IMPORTANT
    };

    await user.save();
    await Payment.create({
      userId: user._id,
      userName: user.name || "User",
      userMobile: user.mobile,
      amount: plan === "Premium" ? 499 : plan === "Basic" ? 199 : 0,
      plan,
      status: "success",
    });

    res.json({ success: true, message: "Plan updated" });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};

/// 🔒 BLOCK / UNBLOCK
exports.toggleUserStatus = async (req, res) => {
  try {
    const { userId } = req.body;

    const user = await User.findById(userId);

    if (!user) {
      return res.json({ success: false, message: "User not found" });
    }

    user.status = user.status === "Active" ? "Blocked" : "Active";

    await user.save();

    res.json({ success: true });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};

/// ================= 🔥 NEW FEATURE =================
/// 🛠 ADMIN FREE LIMIT CONTROL

exports.updateFreeLimit = async (req, res) => {
  try {
    const { limit } = req.body;

    let settings = await AppSettings.findOne();

    if (!settings) {
      settings = new AppSettings({ freeDailyLimit: limit });
    } else {
      settings.freeDailyLimit = limit;
    }

    await settings.save();

    res.json({
      success: true,
      message: "Free limit updated",
      data: settings,
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};

// exports.getSettings = async (req, res) => {
//   try {
//     let settings = await AppSettings.findOne();

//     if (!settings) {
//       settings = await AppSettings.create({ freeDailyLimit: 5 });
//     }

//     res.json({
//       success: true,
//       data: settings,
//     });
//   } catch (err) {
//     res.status(500).json({
//       success: false,
//       message: err.message,
//     });
//   }
// };

/// ================= DASHBOARD =================

// exports.getDashboard = async (req, res) => {
//   try {
//     const totalUsers = await User.countDocuments();
//     const activeSubscriptions = await User.countDocuments({
//       "subscription.plan": { $ne: "free" },
//     });

//     const totalBills = await Bill.countDocuments();

//     res.json({
//       success: true,
//       data: {
//         totalUsers,
//         activeSubscriptions,
//         totalBills,
//         todayRevenue: 0,
//         userGrowth: [],
//         dailyBills: [],
//         recentActivity: [],
//       },
//     });
//   } catch (e) {
//     res.status(500).json({ success: false, message: e.message });
//   }
// };

exports.getPayments = async (req, res) => {
  try {
    const payments = await Payment.find().sort({ createdAt: -1 });

    res.json({
      success: true,
      data: payments,
    });
  } catch (e) {
    res.status(500).json({
      success: false,
      message: e.message,
    });
  }
};

exports.getDashboard = async (req, res) => {
  try {
    /// ================= USERS =================
    const totalUsers = await User.countDocuments();

    const activeSubscriptions = await User.countDocuments({
      "subscription.isActive": true,
    });

    /// ================= BILLS =================
    const totalBills = await Bill.countDocuments();

    /// ================= TODAY REVENUE =================
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const todayBills = await Bill.find({
      createdAt: { $gte: today },
    });

    const todayRevenue = todayBills.reduce(
      (sum, b) => sum + (b.grandTotal || 0),
      0,
    );

    /// ================= USER GROWTH =================
    const users = await User.aggregate([
      {
        $group: {
          _id: { $month: "$createdAt" },
          users: { $sum: 1 },
        },
      },
      { $sort: { _id: 1 } },
    ]);

    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    const userGrowth = users.map((u) => ({
      month: months[u._id - 1],
      users: u.users,
    }));

    /// ================= DAILY BILLS =================
    const last7Days = await Bill.aggregate([
      {
        $match: {
          createdAt: {
            $gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
          },
        },
      },
      {
        $group: {
          _id: { $dayOfWeek: "$createdAt" },
          bills: { $sum: 1 },
        },
      },
      { $sort: { _id: 1 } },
    ]);

    const daysMap = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    const dailyBills = last7Days.map((d) => ({
      day: daysMap[d._id - 1],
      bills: d.bills,
    }));

    /// ================= RECENT ACTIVITY =================
    const recentBills = await Bill.find().sort({ createdAt: -1 }).limit(5);

    const recentActivity = recentBills.map((b) => ({
      id: b._id,
      action: `Bill #${b.billNumber} created`,
      user: b.customerName,
      time: new Date(b.createdAt).toLocaleString(),
    }));

    /// ================= RESPONSE =================
    res.json({
      success: true,
      data: {
        totalUsers,
        activeSubscriptions,
        totalBills,
        todayRevenue,
        userGrowth,
        dailyBills,
        recentActivity,
      },
    });
  } catch (e) {
    console.log("Dashboard Error:", e);
    res.status(500).json({
      success: false,
      message: e.message,
    });
  }
};

/// 💳 PAYMENTS (dummy)

/// 📊 ANALYTICS
// exports.getAnalytics = async (req, res) => {
//   try {
//     /// USER GROWTH
//     const users = await User.aggregate([
//       {
//         $group: {
//           _id: { $month: "$createdAt" },
//           users: { $sum: 1 },
//         },
//       },
//       { $sort: { _id: 1 } },
//     ]);

//     const months = [
//       "Jan",
//       "Feb",
//       "Mar",
//       "Apr",
//       "May",
//       "Jun",
//       "Jul",
//       "Aug",
//       "Sep",
//       "Oct",
//       "Nov",
//       "Dec",
//     ];

//     const userGrowth = users.map((u) => ({
//       month: months[u._id - 1],
//       users: u.users,
//     }));

//     /// DAILY BILLS
//     const last7Days = await Bill.aggregate([
//       {
//         $match: {
//           createdAt: {
//             $gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
//           },
//         },
//       },
//       {
//         $group: {
//           _id: { $dayOfWeek: "$createdAt" },
//           bills: { $sum: 1 },
//         },
//       },
//       { $sort: { _id: 1 } },
//     ]);

//     const daysMap = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

//     const dailyBills = last7Days.map((d) => ({
//       day: daysMap[d._id - 1],
//       bills: d.bills,
//     }));

//     res.json({
//       success: true,
//       data: { userGrowth, dailyBills },
//     });
//   } catch (e) {
//     console.log("Analytics Error:", e);
//     res.status(500).json({
//       success: false,
//       message: e.message,
//     });
//   }
// };

exports.getAnalytics = async (req, res) => {
  try {
    /// ================= USER GROWTH =================
    const users = await User.aggregate([
      {
        $group: {
          _id: { $month: "$createdAt" },
          users: { $sum: 1 },
        },
      },
      { $sort: { _id: 1 } },
    ]);

    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    const userGrowth = users.map((u) => ({
      month: months[u._id - 1],
      users: u.users,
    }));

    /// ================= LAST 7 DAYS =================
    const today = new Date();
    const last7 = new Date();
    last7.setDate(today.getDate() - 6);

    const bills = await Bill.find({
      createdAt: { $gte: last7 },
    });

    /// 🔥 INIT 7 DAYS ARRAY
    const daysMap = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    const dailyMap = {};

    for (let i = 0; i < 7; i++) {
      const d = new Date();
      d.setDate(today.getDate() - i);

      const key = d.toISOString().slice(0, 10);

      dailyMap[key] = {
        day: daysMap[d.getDay()],
        bills: 0,
        revenue: 0,
      };
    }

    /// 🔥 FILL DATA
    bills.forEach((b) => {
      const key = new Date(b.createdAt).toISOString().slice(0, 10);

      if (dailyMap[key]) {
        dailyMap[key].bills += 1;
        dailyMap[key].revenue += b.grandTotal || 0;
      }
    });

    /// 🔥 FINAL ARRAY (sorted)
    const dailyBills = Object.values(dailyMap).reverse();

    /// ================= RESPONSE =================
    res.json({
      success: true,
      data: {
        userGrowth,
        dailyBills,
      },
    });
  } catch (e) {
    console.log("Analytics Error:", e);
    res.status(500).json({
      success: false,
      message: e.message,
    });
  }
};
/// 🔥 GET SETTINGS
exports.getSettings = async (req, res) => {
  try {
    let settings = await AppSettings.findOne();

    if (!settings) {
      settings = await AppSettings.create({});
    }

    res.json({
      success: true,
      data: settings,
    });
  } catch (e) {
    res.status(500).json({
      success: false,
      message: e.message,
    });
  }
};

/// 🔥 UPDATE SETTINGS (FULL CONTROL)
exports.updateSettings = async (req, res) => {
  try {
    let settings = await AppSettings.findOne();

    if (!settings) {
      settings = new AppSettings(req.body);
    } else {
      Object.assign(settings, req.body);
    }

    await settings.save();

    res.json({
      success: true,
      message: "Settings updated",
      data: settings,
    });
  } catch (e) {
    res.status(500).json({
      success: false,
      message: e.message,
    });
  }
};
