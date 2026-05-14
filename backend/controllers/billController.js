// const Bill = require("../models/Bill");
// const Product = require("../models/Product");
// const Customer = require("../models/Customer");
// /// ================= ADD BILL =================
// exports.addBill = async (req, res) => {
//   try {
//     const { items, ownerMobile } = req.body;

//     const bill = new Bill(req.body);
//     await bill.save();

//     // ===============================
//     // 🔥 STOCK REDUCE (FULL FIX)
//     // ===============================

//     if (items && items.length > 0) {
//       for (const item of items) {
//         console.log("🧾 ITEM:", item);

//         const product = await Product.findOne({
//           name: item.name, // ✅ productCode hata diya (issue wahi tha)
//           mobile: ownerMobile,
//         });

//         if (!product) {
//           console.log("❌ Product NOT FOUND:", item.name);
//           continue;
//         }

//         const sellQty = Number(item.qty || item.quantity || 0);

//         if (!sellQty || sellQty <= 0) {
//           console.log("⚠️ Invalid qty:", item);
//           continue;
//         }

//         // ❌ STOCK CHECK
//         if (product.qty < sellQty) {
//           return res.status(400).json({
//             success: false,
//             message: `Not enough stock for ${product.name}`,
//           });
//         }

//         // ✅ UPDATE STOCK
//         product.qty = product.qty - sellQty;

//         await product.save();

//         console.log(`✅ STOCK UPDATED: ${product.name} → ${product.qty}`);
//       }
//     }

//     res.json({
//       success: true,
//       message: "Bill created & stock updated",
//       data: bill,
//     });
//   } catch (error) {
//     console.log("❌ BILL ERROR:", error);

//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

// /// ================= GET BILLS =================
// exports.getBills = async (req, res) => {
//   try {
//     const mobile = req.params.mobile;

//     const bills = await Bill.find({
//       ownerMobile: mobile,
//     }).sort({ createdAt: -1 });

//     res.json({
//       success: true,
//       data: bills,
//     });
//   } catch (error) {
//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

// /// ================= UPDATE BILL =================
// exports.updateBill = async (req, res) => {
//   try {
//     const id = req.params.id;

//     /// 🔥 OLD BILL
//     const oldBill = await Bill.findById(id);

//     if (!oldBill) {
//       return res.status(404).json({
//         success: false,
//         message: "Bill not found",
//       });
//     }

//     /// 🔥 UPDATE BILL
//     const updatedBill = await Bill.findByIdAndUpdate(id, req.body, {
//       new: true,
//     });

//     /// =====================================
//     /// 🔥 CUSTOMER BALANCE LOGIC
//     /// =====================================

//     const customer = await Customer.findOne({
//       mobile: oldBill.mobile,
//       name: oldBill.customerName,
//     });

//     if (customer) {
//       /// ❌ unpaid → paid
//       if (!oldBill.paid && updatedBill.paid) {
//         customer.balance -= oldBill.grandTotal;

//         console.log(`💰 PAID: ${customer.name} balance → ${customer.balance}`);
//       }

//       /// ❌ paid → unpaid (reverse case)
//       if (oldBill.paid && !updatedBill.paid) {
//         customer.balance += oldBill.grandTotal;

//         console.log(
//           `⚠️ UNPAID AGAIN: ${customer.name} balance → ${customer.balance}`,
//         );
//       }

//       await customer.save();
//     }

//     res.json({
//       success: true,
//       data: updatedBill,
//     });
//   } catch (error) {
//     console.log("❌ UPDATE BILL ERROR:", error);

//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

// /// ================= DELETE BILL =================
// exports.deleteBill = async (req, res) => {
//   try {
//     const id = req.params.id;

//     await Bill.findByIdAndDelete(id);

//     res.json({
//       success: true,
//     });
//   } catch (error) {
//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

const Bill = require("../models/Bill");
const Product = require("../models/Product");
const Customer = require("../models/Customer");
const User = require("../models/User"); // 🔥 ADD

/// ================= ADD BILL =================

// exports.addBill = async (req, res) => {
//   try {
//     const { items, ownerMobile } = req.body;

//     if (!ownerMobile) {
//       return res.json({
//         success: false,
//         message: "Mobile required",
//       });
//     }

//     // ✅ USER CHECK (optional rakh sakta hai)
//     const user = await User.findOne({ mobile: ownerMobile });

//     if (!user) {
//       return res.json({
//         success: false,
//         message: "User not found",
//       });
//     }

//     // ===============================
//     // ✅ DIRECT BILL SAVE (NO LIMIT 🚀)
//     // ===============================
//     const bill = new Bill(req.body);
//     await bill.save();

//     // ===============================
//     // 🔥 STOCK REDUCE
//     // ===============================
//     if (items && items.length > 0) {
//       for (const item of items) {
//         const product = await Product.findOne({
//           name: item.name,
//           mobile: ownerMobile,
//         });

//         if (!product) continue;

//         const sellQty = Number(item.qty || item.quantity || 0);

//         if (!sellQty || sellQty <= 0) continue;

//         if (product.qty < sellQty) {
//           return res.status(400).json({
//             success: false,
//             message: `Not enough stock for ${product.name}`,
//           });
//         }

//         product.qty = product.qty - sellQty;
//         await product.save();
//       }
//     }

//     res.json({
//       success: true,
//       message: "Bill created & stock updated",
//       data: bill,
//     });
//   } catch (error) {
//     console.log("❌ BILL ERROR:", error);

//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

const AppSettings = require("../models/AppSettings");

exports.addBill = async (req, res) => {
  try {
    const { items, ownerMobile } = req.body;

    if (!ownerMobile) {
      return res.json({
        success: false,
        message: "Mobile required",
      });
    }

    const user = await User.findOne({ mobile: ownerMobile });

    if (!user) {
      return res.json({
        success: false,
        message: "User not found",
      });
    }

    // ===============================
    // 🔥 GET ADMIN SETTINGS
    // ===============================

    let dailyLimit = 5;

    const settings = await AppSettings.findOne();
    if (settings) {
      dailyLimit = settings.freeDailyLimit; // 🔥 dynamic
    }

    // ===============================
    // 🔥 SUBSCRIPTION LOGIC
    // ===============================

    if (user.subscription?.isActive) {
      // ❌ expired
      if (new Date(user.subscription.endDate) < new Date()) {
        return res.json({
          success: false,
          isLimitReached: true,
          message: "Plan expired",
        });
      }

      // ✅ paid user override
      dailyLimit = user.subscription.dailyLimit;
    }

    // ===============================
    // 🔥 DAILY COUNT
    // ===============================

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const tomorrow = new Date(today);
    tomorrow.setDate(today.getDate() + 1);

    const todayCount = await Bill.countDocuments({
      ownerMobile,
      createdAt: {
        $gte: today,
        $lt: tomorrow,
      },
    });

    // ❌ LIMIT HIT
    if (dailyLimit !== -1 && todayCount >= dailyLimit) {
      return res.json({
        success: false,
        isLimitReached: true,
        message: "Daily limit reached",
      });
    }

    // ===============================
    // ✅ SAVE BILL
    // ===============================

    const bill = new Bill(req.body);
    await bill.save();

    // ===============================
    // 🔥 STOCK REDUCE
    // ===============================

    if (items && items.length > 0) {
      for (const item of items) {
        const product = await Product.findOne({
          name: item.name,
          mobile: ownerMobile,
        });

        if (!product) continue;

        const sellQty = Number(item.qty || item.quantity || 0);

        if (!sellQty || sellQty <= 0) continue;

        if (product.qty < sellQty) {
          return res.status(400).json({
            success: false,
            message: `Not enough stock for ${product.name}`,
          });
        }

        product.qty -= sellQty;
        await product.save();
      }
    }

    res.json({
      success: true,
      message: "Bill created",
      data: bill,
    });
  } catch (error) {
    console.log("❌ BILL ERROR:", error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
/// ================= GET BILLS =================
exports.getBills = async (req, res) => {
  try {
    const mobile = req.params.mobile;

    const bills = await Bill.find({
      ownerMobile: mobile,
    }).sort({ createdAt: -1 });

    res.json({
      success: true,
      data: bills,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/// ================= UPDATE BILL =================
exports.updateBill = async (req, res) => {
  try {
    const id = req.params.id;

    const oldBill = await Bill.findById(id);

    if (!oldBill) {
      return res.status(404).json({
        success: false,
        message: "Bill not found",
      });
    }

    const updatedBill = await Bill.findByIdAndUpdate(id, req.body, {
      new: true,
    });

    const customer = await Customer.findOne({
      mobile: oldBill.mobile,
      name: oldBill.customerName,
    });

    if (customer) {
      if (!oldBill.paid && updatedBill.paid) {
        customer.balance -= oldBill.grandTotal;
      }

      if (oldBill.paid && !updatedBill.paid) {
        customer.balance += oldBill.grandTotal;
      }

      await customer.save();
    }

    res.json({
      success: true,
      data: updatedBill,
    });
  } catch (error) {
    console.log("❌ UPDATE BILL ERROR:", error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/// ================= DELETE BILL =================
exports.deleteBill = async (req, res) => {
  try {
    const id = req.params.id;

    await Bill.findByIdAndDelete(id);

    res.json({
      success: true,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
