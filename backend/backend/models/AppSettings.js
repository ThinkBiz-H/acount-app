const mongoose = require("mongoose");

const appSettingsSchema = new mongoose.Schema({
  freeTrialDays: { type: Number, default: 7 },
  freeDailyLimit: { type: Number, default: 5 },
  defaultPlanDays: { type: Number, default: 30 },
  defaultDailyLimit: { type: Number, default: 100 },
});

module.exports = mongoose.model("AppSettings", appSettingsSchema);
