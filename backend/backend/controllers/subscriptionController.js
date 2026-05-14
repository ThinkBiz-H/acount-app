const User = require("../models/User");

exports.activatePlan = async (req, res) => {
  try {
    const { mobile, days, dailyLimit, planName } = req.body;

    const user = await User.findOne({ mobile });

    if (!user) {
      return res.json({
        success: false,
        message: "User not found",
      });
    }

    const start = new Date();
    const end = new Date();
    end.setDate(start.getDate() + days);

    user.subscription = {
      plan: planName || "pro",
      startDate: start,
      endDate: end,
      isActive: true,
      dailyLimit: dailyLimit || 10,
    };

    await user.save();

    res.json({
      success: true,
      message: "Plan activated",
      endDate: end,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
