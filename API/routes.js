var express = require("express");
var userCtlr = require("./controllers/user")


router = express.Router();

router.route("/users")
    .get(userCtlr.readAllUsers)

module.exports = router;
