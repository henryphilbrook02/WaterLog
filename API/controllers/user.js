//
//Waterlog Capping Group
// Capping class Fall '21
//

var index = require("../index")

// The explanation of what the route does is in the name of the function

exports.readAllUsers = (req, res) => {
    var query = "select * from user";
    index.executeQuery(res, query);
}

exports.readUser = (req, res) => {
    var query = "select * from user where username = '" + req.params.id + "'";
    index.executeQuery(res, query);
}

exports.readUserEmail = (req, res) => {
    var query = "select * from user where email = '" + req.params.id + "'";
    index.executeQuery(res, query);
}

exports.createUser = (req, res) => {
    console.log(req.body)
    var query = "INSERT INTO user(`USERNAME`, `TOKEN`, `WEIGHT`, `HEIGHT`, `BMI`, `GENDER`, `UNIT`, `EMAIL`, `CREATION`, `LAST_UPDATE`) VALUES('" +
        req.body.id + "', '" +
        req.body.tolken + "', " +
        req.body.weight + ", '" +
        req.body.height + "', " +
        req.body.BMI + ", '" +
        req.body.gender + "', '" +
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
        ", GENDER = '" + req.body.gender +
        "', UNIT = '" + req.body.unit +
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