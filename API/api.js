
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
    user: 'WLAdmin',
    password: 'Capping2021',
    server: '10.11.25.59,3306',
    database: 'WaterLogDB'
}

app.get('/', function(req, res){
  // res.render('views/index.html');
});

// Start server and listen on http://localhost:8081/
// Example data but will need to change when server is set up
var server = app.listen(8080, function () {
    var host = server.address().address
    var port = server.address().port

    console.log("app listening at http://%s:%s", host, port)
});

async () => {
    try {
        // make sure that any items are correctly URL encoded in the connection string
        console.log("test")
        const con = await sql.connect('Server=10.11.25.59,3306;Database=WaterLogDB;User Id=WLAdmin;Password=Capping2021;Encrypt=true')
        // const result = await sql.query`select * from mytable where id = ${value}`
        console.log(con)
    } catch (err) {
        // ... error checks
        console.log("This error is:")
        console.log(err)
    }
}

//-----------------
// API DECLARATION
//-----------------

// Example get function

/*
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
*/

// What we will need to add as API calls

/*
USER:
Get used based on name
Update user profile
delete user profile
create user profile

FRIENDS:
Get friends
Remove friends / update friend status

FRIEND REQUEST:
Create request
Delete request / Deny Request

DAY DATA:
Get data for a time range
Create data for a day 
Update data MAYBE

ENTRY:
Create an entry
Delete an entry MAYBE

LOG ENTITY:
Create an entity
update an entity
delete an entity
get an entity

OTHER FUNTIONS:
Check Log In

*/