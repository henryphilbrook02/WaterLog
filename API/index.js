//Initiallising node modules
var express = require("express");
var bodyParser = require("body-parser");
var sql = require("mysql");
var app = express();
var http = require('http');
var server = http.createServer(app);
var routes = require("./routes.js");


// Body Parser Middleware
app.use(bodyParser.json());

// //CORS Middleware
// app.use(function (req, res, next) {
//     //Enabling CORS 
//     res.header("Access-Control-Allow-Origin", "*");
//     res.header("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
//     res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, contentType,Content-Type, Accept, Authorization");
//     next();
// });

//Setting up server (LOCAL VERSION)
// var server = app.listen(process.env.PORT || 8080, function () {
//     var port = server.address().port;
//     console.log("App now running on port", port);
// });

server.listen(process.env.PORT || 443, '10.11.25.60', function () {
    var port = server.address().port;
    console.log("App now running on port", port);
});

//Initiallising connection string
var con = sql.createConnection({
    user: "WLAdmin",
    password: "Capping2021",
    host: "10.11.25.59",
    database: "wlsql"
});

//Function to connect to database and execute query
exports.executeQuery = function (res, query) {
    // query to the database
    con.query(query, (error, results, fields) => {
        if (error) {
            console.log("Error while querying database :- " + error);
            res.send(error);
        }
        else {
            res.send(results);
        }
    });
}

//This will use out routes table
app.use("/api", routes);