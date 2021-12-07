var express = require("express");
var userCtlr = require("./controllers/user")
var presetCtlr = require("./controllers/preset_activity")
var goalCtlr = require("./controllers/goal_log")
var fsCtlr = require("./controllers/friendship")
var entryCtrl = require("./controllers/entry")
var activityCtrl = require("./controllers/activity")

router = express.Router();

router.route("/users")
    .get(userCtlr.readAllUsers)
    .post(userCtlr.createUser)

router.route("/users/:id")
    .get(userCtlr.readUser)
    .put(userCtlr.updateUser)
    .delete(userCtlr.deleteUser)

router.route("/user/:id")
    .get(userCtlr.readUserEmail)

router.route("/presets")
    .get(presetCtlr.readAllPreset)
    .post(presetCtlr.createPreset)

router.route("/presets/:id")
    .get(presetCtlr.readPreset)
    .delete(presetCtlr.deletePreset)
    .put(presetCtlr.updatePreset)

router.route("/goals")
    .get(goalCtlr.readAllGoals)
    .post(goalCtlr.createGoal)

router.route("/goals/:id")
    .get(goalCtlr.readGoal)
    .delete(goalCtlr.deleteGoal)
    .put(goalCtlr.updateGoal)

router.route("/cur_goals/:user")
    .get(goalCtlr.curUserGoal)

router.route("/user_goals/:user")
    .get(goalCtlr.userGoal)

router.route("/fs")
    .get(fsCtlr.readAllFriendships)
    .post(fsCtlr.createFriendship)

router.route("/fs/:id")
    .get(fsCtlr.readFriendship)
    .delete(fsCtlr.deleteFriendship)
    .put(fsCtlr.updateFriendship)

router.route("/ufs/:id")
    .get(fsCtlr.readFriends)

router.route("/pfs/:id")
    .get(fsCtlr.readPendingFriends)
    .put(fsCtlr.updateAccept)

router.route("/entries")
    .get(entryCtrl.readAllEntries)
    .post(entryCtrl.createEntry)

router.route("/entries/:id")
    .get(entryCtrl.readEntry)
    .delete(entryCtrl.deleteEntry)
    .put(entryCtrl.updateEntry)

router.route("/user_entries/:user")
    .get(entryCtrl.userEntries)

router.route("/seven_day_entries/:user")
    .get(entryCtrl.sevenDayEntries)

router.route("/user_week_entries/:user")
    .get(entryCtrl.weekEntries)

router.route("/user_date_entries/:user")
    .get(entryCtrl.userDateEntries)

router.route("/cur_day_data/:user")
    .get(entryCtrl.dayTotal)

router.route("/seven_day_data/:user")
    .get(entryCtrl.sevenDayTotal)

router.route("/week_data/:user")
    .get(entryCtrl.weekTotal)

router.route("/seven_day_readout/:user")
    .get(entryCtrl.sevenDayReadout)

router.route("/week_readout/:user")
    .get(entryCtrl.weekReadout)

router.route("/activities")
    .get(activityCtrl.readAllActivities)
    .post(activityCtrl.createActivity)

router.route("/activities/:id")
    .get(activityCtrl.readActivity)
    .delete(activityCtrl.deleteActivity)
    .put(activityCtrl.updateActivity)

router.route("/user_activities/:user")
    .get(activityCtrl.userActivities)

module.exports = router;
