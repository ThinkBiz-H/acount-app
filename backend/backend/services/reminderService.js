const cron = require("node-cron");
const Reminder = require("../models/Reminder");
const { sendSMS } = require("./smsService");

/// =============================
/// AUTO REMINDER CRON
/// =============================
/// Runs every 1 minute

cron.schedule("* * * * *", async () => {
  try {
    const now = new Date();

    const reminders = await Reminder.find({
      date: { $lte: now },
      sent: false,
    });

    if (reminders.length === 0) return;

    console.log("🔔 Reminders found:", reminders.length);

    for (const r of reminders) {
      const message = `Reminder: ${r.customerName}, please clear your pending amount of ₹${r.amount}.`;

      if (r.mobile) {
        await sendSMS(r.mobile, message);
      }

      r.sent = true;
      await r.save();

      console.log("✅ Reminder sent to:", r.customerName);
    }
  } catch (error) {
    console.log("❌ Reminder error:", error.message);
  }
});
