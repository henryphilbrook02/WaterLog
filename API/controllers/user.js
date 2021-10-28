var index = require("../index")


exports.readAllUsers = (req, res) => {
    var query = "select * from user";
    index.executeQuery(res, query);
}
