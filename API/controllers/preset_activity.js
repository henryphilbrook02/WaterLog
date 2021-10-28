var index = require("../index")

exports.readAllPreset = (req, res) => {
    var query = "select * from preset_activity";
    index.executeQuery(res, query);
}

exports.readPreset = (req, res) => {
    var query = "select * from preset_activity where activity_id = " + req.params.id;
    index.executeQuery(res, query);
}