var index = require("../index")

exports.readAllFriendships = (req, res) => {
    var query = "select * from friendship";
    index.executeQuery(res, query);
}

exports.readFriendship = (req, res) => {
    var query = "select * from friendship where fs_id = " + req.params.id;
    index.executeQuery(res, query);
}

exports.createFriendship = (req, res) => {
    var query = "";
    index.executeQuery(res, query);
}

exports.updateFriendship = (req, res) => {
    var query = "";
    index.executeQuery(res, query);
}

exports.deleteFriendship = (req, res) => {
    var query = "";
    index.executeQuery(res, query);
}