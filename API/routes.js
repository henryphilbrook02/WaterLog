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

router.route("/presets")
    .get(presetCtlr.readAllPreset)

router.route("/presets/:id")
    .get(presetCtlr.readPreset)

router.route("/goals")
    .get(goalCtlr.readAllGoals)

router.route("/goals/:id")
    .get(goalCtlr.readGoal)

router.route("/fs")
    .get(fsCtlr.readAllFriendships)

router.route("/fs/:id")
    .get(fsCtlr.readFriendship)

router.route("/entries")
    .get(entryCtrl.readAllEntries)

router.route("/entries/:id")
    .get(entryCtrl.readEntry)

router.route("/activities")
    .get(activityCtrl.readAllActivities)

router.route("/activities/:id")
    .get(activityCtrl.readActivity)

module.exports = router;
