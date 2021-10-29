//Initiallising node modules
var express = require("express");
var bodyParser = require("body-parser");
var sql = require("mysql");
var app = express();
var routes = require("./routes.js");

// Body Parser Middleware
app.use(bodyParser.json());

//CORS Middleware
app.use(function (req, res, next) {
    //Enabling CORS 
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, contentType,Content-Type, Accept, Authorization");
    next();
});

//Setting up server
var server = app.listen(process.env.PORT || 8080, function () {
    var port = server.address().port;
    console.log("App now running on port", port);
});

//Initiallising connection string
var con = sql.createConnection({
    user: "WLAdmin",
    password: "Capping2021",
    server: "10.11.25.59",
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
/*
//Function to connect to database and execute query
exports.executeQuery = function (res, query) {
    con.connect(function (err) {
        if (err) {
            console.log("Error while connecting database :- " + err);
            res.send(err);
        }
        else {
            // query to the database
            con.query(query, (error, results, fields) => {
                if (err) {
                    console.log("Error while querying database :- " + error);
                    res.send(error);
                }
                else {
                    res.send(results);
                }
            });
        }
    });
}
*/

app.use("/api", routes);

/*
//GET API
app.get("/api/users", function (req, res) {
    var query = "select * from user";
    executeQuery(res, query);
});


//POST API
 app.post("/api/user", function(req , res){
                var query = "INSERT INTO user (Name,Email,Password) VALUES (req.body.Name,req.body.Email,req.body.Password";
                executeQuery (res, query);
});

//PUT API
 app.put("/api/user/:id", function(req , res){
                var query = "UPDATE user SET Name= " + req.body.Name  +  " , Email=  " + req.body.Email + "  WHERE Id= " + req.params.id;
                executeQuery (res, query);
});

// DELETE API
 app.delete("/api/user /:id", function(req , res){
                var query = "DELETE FROM [user] WHERE Id=" + req.params.id;
                executeQuery (res, query);
});

*/

