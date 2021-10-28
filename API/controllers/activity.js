var index = require("../index")


exports.readAllActivities = (req, res) => {
    var query = "select * from activity";
    index.executeQuery(res, query);
}

exports.readActivity = (req, res) => {
    var query = "select * from activity where activity_id = " + req.params.id;
    index.executeQuery(res, query);
}

exports.createActivity = (req, res) => {
    var query = "";
    index.executeQuery(res, query);
}

exports.updateActivity = (req, res) => {
    var query = "";
    index.executeQuery(res, query);
}

exports.deleteActivity = (req, res) => {
    var query = "";
    index.executeQuery(res, query);
}