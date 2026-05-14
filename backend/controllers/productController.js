// const Product = require("../models/Product");

// exports.addProduct = async (req, res) => {
//   const product = new Product(req.body);

//   await product.save();

//   res.json(product);
// };

// exports.getProducts = async (req, res) => {
//   const { mobile } = req.params;

//   const products = await Product.find({ mobile });

//   res.json(products);
// };

// exports.updateProduct = async (req, res) => {
//   const { id } = req.params;

//   const product = await Product.findByIdAndUpdate(id, req.body, { new: true });

//   res.json(product);
// };

// exports.deleteProduct = async (req, res) => {
//   const { id } = req.params;

//   await Product.findByIdAndDelete(id);

//   res.json({ message: "Deleted" });
// };

// const Product = require("../models/Product");

// /// ADD PRODUCT
// exports.addProduct = async (req, res) => {
//   try {
//     const {
//       mobile,
//       name,
//       mrp,
//       qty,
//       unit,
//       rate,
//       date,
//       tax,
//       taxType,
//       productCode,
//       imagePath,
//     } = req.body;

//     if (!mobile) {
//       return res.status(400).json({ message: "Mobile required" });
//     }

//     const product = new Product({
//       mobile,
//       name,
//       mrp,
//       qty,
//       unit,
//       rate,
//       date,
//       tax,
//       taxType,
//       productCode,
//       imagePath,
//     });

//     await product.save();

//     res.json(product);
//   } catch (err) {
//     res.status(500).json({ message: err.message });
//   }
// };

// /// GET PRODUCTS BY MOBILE
// exports.getProducts = async (req, res) => {
//   try {
//     const { mobile } = req.params;

//     const products = await Product.find({ mobile });

//     res.json(products);
//   } catch (err) {
//     res.status(500).json({ message: err.message });
//   }
// };

// /// UPDATE PRODUCT
// exports.updateProduct = async (req, res) => {
//   try {
//     const { id } = req.params;

//     const product = await Product.findByIdAndUpdate(id, req.body, {
//       new: true,
//     });

//     res.json(product);
//   } catch (err) {
//     res.status(500).json({ message: err.message });
//   }
// };

// exports.deleteProduct = async (req, res) => {
//   const { id } = req.params;

//   await Product.findOneAndDelete({ productCode: id });

//   res.json({ message: "Deleted" });
// };

const Product = require("../models/Product");

/// ================= ADD PRODUCT =================
exports.addProduct = async (req, res) => {
  try {
    const {
      mobile,
      name,
      mrp,
      qty,
      unit,
      rate,
      date,
      tax,
      taxType,
      productCode,
      imagePath,
    } = req.body;

    if (!mobile) {
      return res.status(400).json({ message: "Mobile required" });
    }

    /// 🔥 CHECK DUPLICATE (IMPORTANT FIX)
    const existing = await Product.findOne({ productCode });

    if (existing) {
      return res.status(400).json({
        success: false,
        message: "Product already exists",
      });
    }

    const product = new Product({
      mobile,
      name,
      mrp,
      qty,
      unit,
      rate,
      date,
      tax,
      taxType,
      productCode,
      imagePath,
    });

    await product.save();

    res.json(product);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

/// ================= GET PRODUCTS =================
exports.getProducts = async (req, res) => {
  try {
    const { mobile } = req.params;

    const products = await Product.find({ mobile });

    res.json(products);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

/// ================= UPDATE PRODUCT (FINAL FIX) =================
exports.updateProduct = async (req, res) => {
  try {
    const { code } = req.params;

    const updated = await Product.findOneAndUpdate(
      { productCode: code }, // 🔥 MATCH BY productCode
      req.body,
      { new: true },
    );

    if (!updated) {
      return res.status(404).json({
        success: false,
        message: "Product not found",
      });
    }

    res.json(updated);
  } catch (err) {
    console.error("Update Product Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/// ================= DELETE PRODUCT =================
exports.deleteProduct = async (req, res) => {
  try {
    const { id } = req.params;

    await Product.findOneAndDelete({ productCode: id });

    res.json({ message: "Deleted" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
