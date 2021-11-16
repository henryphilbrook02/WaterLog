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
    console.log(req.body)
    var query = "INSERT INTO user(`USERNAME`, `TOKEN`, `WEIGHT`, `HEIGHT`, `BMI`, `CUR_USAGE`, `UNIT`, `EMAIL`, `CREATION`, `LAST_UPDATE`) VALUES('" +
        req.body.id + "', '" +
        req.body.tolken + "', " +
        req.body.weight + ", '" +
        req.body.height + "', " +
        req.body.BMI + ", " +
        req.body.curUsage + ", '" +
        req.body.unit + "', '" +
        req.body.email + "', '" +
        req.body.creation + "', '" +
        req.body.update + "')";
    index.executeQuery(res, query);
}

exports.updateUser = (req, res) => {
    var query = "UPDATE user " +
        "SET TOKEN = '" + req.body.tolken +
        "', WEIGHT = " + req.body.weight +
        ", HEIGHT = '" + req.body.height +
        "', BMI = " + req.body.BMI +
        ", CUR_USAGE = " + req.body.curUsage +
        ", UNIT = '" + req.body.unit +
        "', EMAIL = '" + req.body.email +
        "', CREATION = '" + req.body.creation +
        "', LAST_UPDATE = '" + req.body.update + "' " +
        "WHERE(USERNAME = '" + req.params.id + "')";
    index.executeQuery(res, query);
}

exports.deleteUser = (req, res) => {
    var query = "DELETE FROM user WHERE username = '" + req.params.id + "'";
    index.executeQuery(res, query);
}  