// const Transaction = require("../models/Transaction");
// const Customer = require("../models/Customer");
// const { sendPhoneSMS } = require("../services/phoneSMSService");

// /// ================= ADD TRANSACTION =================

// exports.addTransaction = async (req, res) => {
//   try {
//     const { ownerMobile, customerId, type, amount, note } = req.body;

//     /// ================= VALIDATION =================

//     if (!ownerMobile || !customerId || !type || !amount) {
//       return res.status(400).json({
//         success: false,
//         message: "Required fields missing",
//       });
//     }

//     /// ================= CREATE TRANSACTION =================

//     const transaction = new Transaction({
//       ownerMobile,
//       customerId,
//       type,
//       amount,
//       note,
//     });

//     await transaction.save();

//     /// ================= FETCH CUSTOMER =================

//     const customer = await Customer.findById(customerId);

//     /// ================= SEND SMS =================

//     if (customer && customer.mobile) {
//       let message = "";

//       if (type === "credit") {
//         message = `₹${amount} received from ${customer.name}. Thank you! - Smart Bahi`;
//       } else {
//         message = `₹${amount} added to your account. - Smart Bahi`;
//       }

//       await sendPhoneSMS(customer.mobile, message);
//     }

//     /// ================= RESPONSE =================

//     res.status(200).json({
//       success: true,
//       data: transaction,
//       message: "Transaction saved successfully",
//     });
//   } catch (error) {
//     console.error("Transaction Error:", error);

//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

// /// ================= GET CUSTOMER TRANSACTIONS =================

// exports.getCustomerTransactions = async (req, res) => {
//   try {
//     const { customerId } = req.params;

//     if (!customerId) {
//       return res.status(400).json({
//         success: false,
//         message: "Customer ID required",
//       });
//     }

//     const transactions = await Transaction.find({ customerId }).sort({
//       createdAt: -1,
//     });

//     res.status(200).json({
//       success: true,
//       count: transactions.length,
//       data: transactions,
//     });
//   } catch (error) {
//     console.error("Fetch Transaction Error:", error);

//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

// // aaj ka code hai //
// //

// const Transaction = require("../models/Transaction");
// const Customer = require("../models/Customer");
// const { sendPhoneSMS } = require("../services/phoneSMSService");

// /// ================= ADD TRANSACTION =================

// exports.addTransaction = async (req, res) => {
//   try {
//     const { ownerMobile, customerId, type, amount, note } = req.body;

//     /// ================= VALIDATION =================

//     if (!ownerMobile || !customerId || !type || !amount) {
//       return res.status(400).json({
//         success: false,
//         message: "Required fields missing",
//       });
//     }

//     /// ================= CREATE TRANSACTION =================

//     const transaction = new Transaction({
//       ownerMobile,
//       customerId,
//       type,
//       amount,
//       note,
//     });

//     await transaction.save();

//     /// ================= FETCH CUSTOMER =================

//     const customer = await Customer.findById(customerId);

//     /// ================= SEND SMS (NON-BLOCKING 🔥) =================

//     if (customer && customer.mobile) {
//       let message = "";

//       if (type === "credit") {
//         message = `₹${amount} received from ${customer.name}. Thank you! - Smart Bahi`;
//       } else {
//         message = `₹${amount} added to your account. - Smart Bahi`;
//       }

//       // 🔥 IMPORTANT: background me SMS bhejna (API fast ho jayegi)
//       setTimeout(() => {
//         sendPhoneSMS(customer.mobile, message);
//       }, 0);
//     }

//     /// ================= RESPONSE =================

//     res.status(200).json({
//       success: true,
//       data: transaction,
//       message: "Transaction saved successfully",
//     });
//   } catch (error) {
//     console.error("Transaction Error:", error);

//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

// /// ================= GET CUSTOMER TRANSACTIONS =================

// exports.getCustomerTransactions = async (req, res) => {
//   try {
//     const { customerId } = req.params;

//     if (!customerId) {
//       return res.status(400).json({
//         success: false,
//         message: "Customer ID required",
//       });
//     }

//     const transactions = await Transaction.find({ customerId }).sort({
//       createdAt: -1,
//     });

//     res.status(200).json({
//       success: true,
//       count: transactions.length,
//       data: transactions,
//     });
//   } catch (error) {
//     console.error("Fetch Transaction Error:", error);

//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

///20/3/25
const Transaction = require("../models/Transaction");
const Customer = require("../models/Customer");
const { sendPhoneSMS } = require("../services/phoneSMSService");

/// ================= ADD TRANSACTION =================

exports.addTransaction = async (req, res) => {
  try {
    const { ownerMobile, customerId, type, amount, note } = req.body;

    if (!ownerMobile || !customerId || !type || !amount) {
      return res.status(400).json({
        success: false,
        message: "Required fields missing",
      });
    }

    const transaction = new Transaction({
      ownerMobile,
      customerId,
      type,
      amount,
      note,
    });

    await transaction.save();

    const customer = await Customer.findById(customerId);

    if (customer && customer.mobile) {
      let message = "";

      if (type === "credit") {
        message = `₹${amount} received from ${customer.name}. Thank you! - Smart Bahi`;
      } else {
        message = `₹${amount} added to your account. - Smart Bahi`;
      }

      setTimeout(() => {
        sendPhoneSMS(customer.mobile, message);
      }, 0);
    }

    res.status(200).json({
      success: true,
      data: transaction,
      message: "Transaction saved successfully",
    });
  } catch (error) {
    console.error("Transaction Error:", error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/// ================= GET CUSTOMER TRANSACTIONS =================

exports.getCustomerTransactions = async (req, res) => {
  try {
    const { customerId } = req.params;

    if (!customerId) {
      return res.status(400).json({
        success: false,
        message: "Customer ID required",
      });
    }

    const transactions = await Transaction.find({ customerId }).sort({
      createdAt: -1,
    });

    res.status(200).json({
      success: true,
      count: transactions.length,
      data: transactions,
    });
  } catch (error) {
    console.error("Fetch Transaction Error:", error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/// ================= GET TRANSACTIONS BY DATE RANGE (SINGLE CUSTOMER) =================

exports.getTransactionsByDateRange = async (req, res) => {
  try {
    const { customerId, startDate, endDate } = req.body;

    if (!customerId || !startDate || !endDate) {
      return res.status(400).json({
        success: false,
        message: "customerId, startDate and endDate are required",
      });
    }

    const start = new Date(startDate);
    const end = new Date(endDate);
    end.setHours(23, 59, 59, 999);

    const transactions = await Transaction.find({
      customerId,
      createdAt: {
        $gte: start,
        $lte: end,
      },
    }).sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: transactions.length,
      data: transactions,
    });
  } catch (error) {
    console.error("Date Filter Error:", error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/// ================= GET ALL TRANSACTIONS BY DATE RANGE (STATEMENT 🔥) =================

exports.getAllTransactionsByDateRange = async (req, res) => {
  try {
    const { startDate, endDate } = req.body;

    if (!startDate || !endDate) {
      return res.status(400).json({
        success: false,
        message: "startDate and endDate are required",
      });
    }

    const start = new Date(startDate);
    const end = new Date(endDate);
    end.setHours(23, 59, 59, 999);

    const transactions = await Transaction.find({
      createdAt: {
        $gte: start,
        $lte: end,
      },
    })
      .populate("customerId", "name mobile") // 🔥 important
      .sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: transactions.length,
      data: transactions,
    });
  } catch (error) {
    console.error("All Date Filter Error:", error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
