var index = require("../index")


exports.readAllEntries = (req, res) => {
    var query = "select * from entry";
    index.executeQuery(res, query);
}

exports.readEntry = (req, res) => {
    var query = "select * from entry where entry_id = " + req.params.id;
    index.executeQuery(res, query);
}

exports.createEntry = (req, res) => {
    var query = "";
    index.executeQuery(res, query);
}

exports.updateEntry = (req, res) => {
    var query = "";
    index.executeQuery(res, query);
}

exports.deleteEntry = (req, res) => {
    var query = "";
    index.executeQuery(res, query);
}