//
//Waterlog Capping Group
// Capping class Fall '21
//

var index = require("../index")

// The explanation of what the route does is in the name of the function

exports.readAllActivities = (req, res) => {
    var query = "select * from activity";
    index.executeQuery(res, query);
}

exports.readActivity = (req, res) => {
    var query = "select * from activity where activity_id = " + req.params.id;
    index.executeQuery(res, query);
}

exports.userActivities = (req, res) => {
    var query = "select * from activity where USERNAME = '" + req.params.user + "'";
    index.executeQuery(res, query);
}

exports.createActivity = (req, res) => {
    var query = "INSERT INTO activity (`USERNAME`, `NAME`, `AMOUNT`, `UNIT`, `CREATION`, `LAST_UPDATE`) VALUES('" +
        req.body.username + "', '" +
        req.body.name + "', " +
        req.body.amount + ", '" +
        req.body.units + "', '" +
        req.body.creation + "', '" +
        req.body.update + "')";
    index.executeQuery(res, query);
}

exports.updateActivity = (req, res) => {
    var query = "UPDATE activity " +
        "SET NAME = '" + req.body.name +
        "', AMOUNT = " + req.body.amount +
        ", UNIT = '" + req.body.units +
        "', CREATION = '" + req.body.creation +
        "', LAST_UPDATE = '" + req.body.update + "' " +
        "WHERE(ACTIVITY_ID = " + req.params.id + ")";
    index.executeQuery(res, query);
}

exports.deleteActivity = (req, res) => {
    var query = "DELETE FROM activity WHERE ACTIVITY_ID = " + req.params.id;
    index.executeQuery(res, query);
}