//
//Waterlog Capping Group
// Capping class Fall '21
//

var index = require("../index")

// The explanation of what the route does is in the name of the function

exports.readAllGoals = (req, res) => {
    var query = "select * from goal_log";
    index.executeQuery(res, query);
}

exports.readGoal = (req, res) => {
    var query = "select * from goal_log where goal_id = " + req.params.id;
    index.executeQuery(res, query);
}

exports.userGoal = (req, res) => {
    var query = "select * from goal_log where USERNAME = '" + req.params.user +"'";
    index.executeQuery(res, query);
}

exports.curUserGoal = (req, res) => {
    var query = "select * from goal_log where USERNAME = '" + req.params.user +"' and CURRENT = "+ 1;
    index.executeQuery(res, query);
}

exports.createGoal = (req, res) => {
    var query = "INSERT INTO goal_log(`USERNAME`, `GOAL`, `CURRENT`, `CREATION`) VALUES('" +
        req.body.username + "', " +
        req.body.goal + ", " +
        req.body.current + ", '" +
        req.body.creation + "')";
    index.executeQuery(res, query);
}

exports.updateGoal = (req, res) => {
    var query = "UPDATE goal_log " +
        "SET USERNAME = '" + req.body.username +
        "', GOAL = " + req.body.goal +
        ", CURRENT = " + req.body.current +
        ", CREATION = '" + req.body.creation + "' " +
        "WHERE(GOAL_ID = " + req.params.id + ")";
    index.executeQuery(res, query);
}

exports.deleteGoal = (req, res) => {
    var query = "DELETE FROM goal_log WHERE goal_id = " + req.params.id;
    index.executeQuery(res, query);
}