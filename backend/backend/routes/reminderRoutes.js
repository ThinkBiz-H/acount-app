const express = require("express");
const router = express.Router();
const Reminder = require("../models/Reminder");

router.post("/", async (req, res) => {
  const reminder = new Reminder(req.body);
  await reminder.save();
  res.json(reminder);
});

router.get("/", async (req, res) => {
  const reminders = await Reminder.find();
  res.json(reminders);
});

module.exports = router;
