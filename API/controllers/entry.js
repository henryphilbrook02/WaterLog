var index = require("../index")


exports.readAllEntries = (req, res) => {
    var query = "select * from entry";
    index.executeQuery(res, query);
}

exports.readEntry = (req, res) => {
    var query = "select * from entry where entry_id = " + req.params.id;
    index.executeQuery(res, query);
}

exports.userEntries = (req, res) => {
    var query = "select * from entry where USERNAME = '" + req.params.user + "'";
    index.executeQuery(res, query);
}

exports.userDateEntries = (req, res) => {
    var query = "select * from entry where USERNAME = '" + req.params.user +
        "' AND DAY >= '" + req.body.startDate + "' and DAY <= '" + req.body.endDate + "'";
    index.executeQuery(res, query);
}

exports.createEntry = (req, res) => {
    var query = "INSERT INTO entry (`ACTIVITY_ID`, `PRESET_ID`, `USERNAME`, `DAY`, `AMOUNT`) VALUES(" +
        req.body.activity_id + ", " +
        req.body.preset_id + ", '" +
        req.body.username + "', '" +
        req.body.day + "', " +
        req.body.amount + ")";
    index.executeQuery(res, query);
}

exports.updateEntry = (req, res) => {
    var query = "UPDATE entry " +
        "SET ACTIVITY_ID = " + req.body.activity_id +
        ", PRESET_ID = " + req.body.preset_id +
        ", USERNAME = '" + req.body.username +
        "', DAY = '" + req.body.day +
        "', AMOUNT = " + req.body.amount +
        " WHERE(ENTRY_ID = '" + req.params.id + "')";;
    index.executeQuery(res, query);

}

exports.deleteEntry = (req, res) => {
    var query = "DELETE FROM entry WHERE ENTRY_ID = " + req.params.id;
    index.executeQuery(res, query);
}