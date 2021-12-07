var index = require("../index")

//NOTE: needs to add a check in Flutter to make sure that the FKs are different
exports.readAllFriendships = (req, res) => {
    var query = "select * from friendship";
    index.executeQuery(res, query);
}

exports.readFriendship = (req, res) => {
    var query = "select * from friendship where fs_id = " + req.params.id;
    index.executeQuery(res, query);
}

exports.readFriends = (req, res) => {
    var query = "SELECT * FROM wlsql.friendship where ACCEPTED = 1 and (REQUESTED = '"+req.params.id+"' or REQUESTEE = '"+req.params.id+"')";
    index.executeQuery(res, query);
}

exports.readPendingFriends = (req, res) => {
    var query = "SELECT * FROM wlsql.friendship where ACCEPTED = 0 and REQUESTED = '"+req.params.id+"'";
    index.executeQuery(res, query);
}

exports.createFriendship = (req, res) => {
    var query = "INSERT INTO friendship (`REQUESTED`, `REQUESTEE`, `ACCEPTED`, `CREATION`, `LAST_UPDATE`) VALUES ('" +
        req.body.requested + "', '" +
        req.body.requestee + "', " +
        req.body.accepted + ", '" +
        req.body.creation + "', '" +
        req.body.update + "')";
    index.executeQuery(res, query);
}

exports.updateFriendship = (req, res) => {
    var query = "UPDATE friendship " +
        "SET REQUESTED = '" + req.body.requested +
        "', REQUESTEE = '" + req.body.requestee +
        "', ACCEPTED = " + req.body.accepted +
        ", CREATION = '" + req.body.creation +
        "', LAST_UPDATE = '" + req.body.update + "' " +
        "WHERE(FS_ID = '" + req.params.id + "')";
    index.executeQuery(res, query);
}

exports.updateAccept = (req, res) => {
    var query = "UPDATE friendship " +
        "SET ACCEPTED = " + req.body.accepted +
        " WHERE(FS_ID = '" + req.params.id + "')";
    index.executeQuery(res, query);
}

exports.deleteFriendship = (req, res) => {
    var query = "DELETE FROM friendship WHERE FS_ID = " + req.params.id;
    index.executeQuery(res, query);
}