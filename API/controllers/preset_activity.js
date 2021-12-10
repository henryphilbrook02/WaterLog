//
//Waterlog Capping Group
// Capping class Fall '21
//

var index = require("../index")

// The explanation of what the route does is in the name of the function

exports.readAllPreset = (req, res) => {
    var query = "select * from preset_activity";
    index.executeQuery(res, query);
}

exports.readPreset = (req, res) => {
    var query = "select * from preset_activity where activity_id = " + req.params.id;
    index.executeQuery(res, query);
}

exports.createPreset = (req, res) => {
    var query = "INSERT INTO preset_activity (`NAME`, `AMOUNT`, `UNIT`, `CREATION`, `LAST_UPDATE`) VALUES('" +
        req.body.name + "', " +
        req.body.amount + ", '" +
        req.body.units +"', '" +
        req.body.creation + "', '" +
        req.body.update + "')";
    index.executeQuery(res, query);
}

exports.updatePreset = (req, res) => {
    var query = "UPDATE preset_activity " +
        "SET NAME = '" + req.body.name +
        "', AMOUNT = " + req.body.amount +
        ", UNIT = '" + req.body.units +
        "', CREATION = '" + req.body.creation +
        "', LAST_UPDATE = '" + req.body.update + "' " +
        "WHERE(ACTIVITY_ID = " + req.params.id + ")";
    index.executeQuery(res, query);
}

exports.deletePreset = (req, res) => {
    var query = "DELETE FROM preset_activity WHERE activity_id = " + req.params.id;
    index.executeQuery(res, query);
}  