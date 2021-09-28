
// https://www.telerik.com/blogs/step-by-step-create-node-js-rest-api-sql-server-database

//-------------------
// SET UP FOR SERVER
//-------------------
var express = require('express'); // Web Framework
var app = express();
var sql = require('mssql'); // MS Sql Server client

// Connection string parameters.
// Example Data for now
var sqlConfig = {
    user: 'UserName',
    password: 'password',
    server: 'localhost',
    database: 'DatabaseName'
}

// Start server and listen on http://localhost:8081/
// Example data but will need to change when server is set up
var server = app.listen(8081, function () {
    var host = server.address().address
    var port = server.address().port

    console.log("app listening at http://%s:%s", host, port)
});


//-----------------
// API DECLARATION
//-----------------

// Example get function
app.get('/customers/:customerId/', function (req, res) {
    sql.connect(sqlConfig, function() {
        var request = new sql.Request();
        var stringRequest = 'select * from Sales.Customer where customerId = ' + req.params.customerId;
        request.query(stringRequest, function(err, recordset) {
            if(err) console.log(err);
            res.end(JSON.stringify(recordset)); // Result in JSON format
        });
    });
});