// const Customer = require("../models/Customer");

// /// ADD CUSTOMER
// exports.addCustomer = async (req, res) => {
//   try {
//     const { ownerMobile, name, mobile, address, type } = req.body;

//     const customer = new Customer({
//       ownerMobile,
//       name,
//       mobile,
//       address,
//       type,
//     });

//     await customer.save();

//     res.json({
//       success: true,
//       customer,
//     });
//   } catch (err) {
//     console.log("Customer Save Error:", err);

//     res.status(500).json({
//       success: false,
//       message: err.message,
//     });
//   }
// };

// /// GET CUSTOMERS
// exports.getCustomers = async (req, res) => {
//   try {
//     const ownerMobile = req.params.mobile;

//     const customers = await Customer.find({
//       ownerMobile: ownerMobile,
//     });

//     res.json(customers);
//   } catch (err) {
//     console.log("Get Customers Error:", err);

//     res.status(500).json({
//       message: err.message,
//     });
//   }
// };
// exports.updateCustomer = async (req, res) => {
//   try {
//     const { id } = req.params;

//     const customer = await Customer.findByIdAndUpdate(id, req.body, {
//       new: true,
//     });

//     res.json({
//       success: true,
//       data: customer,
//     });
//   } catch (error) {
//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };
const Customer = require("../models/Customer");

/// ADD CUSTOMER
exports.addCustomer = async (req, res) => {
  try {
    const { ownerMobile, name, mobile, address, type } = req.body;

    const customer = new Customer({
      ownerMobile,
      name,
      mobile,
      address,
      type,
    });

    await customer.save();

    res.json({
      success: true,
      data: customer,
    });
  } catch (err) {
    console.log("Customer Save Error:", err);

    res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};

/// GET CUSTOMERS

exports.getCustomers = async (req, res) => {
  try {
    const ownerMobile = req.params.mobile;

    const customers = await Customer.find({
      ownerMobile: ownerMobile,
    });

    res.json({
      success: true,
      data: customers,
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};
/// UPDATE CUSTOMER

exports.updateCustomer = async (req, res) => {
  try {
    const { id } = req.params;

    const customer = await Customer.findByIdAndUpdate(id, req.body, {
      returnDocument: "after",
    });

    res.json({
      success: true,
      data: customer,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
exports.deleteCustomer = async (req, res) => {
  try {
    const { id } = req.params;

    await Customer.findByIdAndDelete(id);

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
