var index = require("../index")

exports.readAllGoals = (req, res) => {
    var query = "select * from goal_log";
    index.executeQuery(res, query);
}

exports.readGoal = (req, res) => {
    var query = "select * from goal_log where goal_id = " + req.params.id;
    index.executeQuery(res, query);
}

exports.createGoal = (req, res) => {
    var query = "";
    index.executeQuery(res, query);
}

exports.updateGoal = (req, res) => {
    var query = "";
    index.executeQuery(res, query);
}

exports.deleteGoal = (req, res) => {
    var query = "";
    index.executeQuery(res, query);
}