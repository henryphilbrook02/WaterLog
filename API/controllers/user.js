var index = require("../index")


exports.readAllUsers = (req, res) => {
    var query = "select * from user";
    index.executeQuery(res, query);
}

exports.readUser = (req, res) => {
    var query = "select * from user where username = '" + req.params.id + "'";
    index.executeQuery(res, query);
}

exports.createUser = (req, res) => {
    var query =
    "INSERT INTO user(`USERNAME`, `TOKEN`, `WEIGHT`, `HEIGHT`, `BMI`, `CUR_USAGE`, `UNIT`, `CREATION`, `UPDATE`) VALUES("Maaloufer", "we may not need this", 150, 5.9, 28, 48, 0, NOW(), NOW())";
    index.executeQuery(res, query);
}

exports.updateUser = (req, res) => {
    var query = "";
    index.executeQuery(res, query);
}

exports.deleteUser = (req, res) => {
    var query = "";
    index.executeQuery(res, query);
}