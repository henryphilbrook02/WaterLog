//
//Waterlog Capping Group
//Capping class Fall '21
//

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

// This is the entries dueing a specific date
exports.userDateEntries = (req, res) => {
    var query = "select * from entry where USERNAME = '" + req.params.user +
        "' AND DAY > '" + req.body.startDate + "' and DAY <= '" + req.body.endDate + "'";
    index.executeQuery(res, query);
}

// Gets the entried for the week you are in ex. if its tuesday the 10th it will return sunday 8th - saturday 14th 
exports.sevenDayEntries = (req, res) => {
    var today = new Date();
    var curDate = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate()
   
    today.setDate(today.getDate() - 7);
    var pastDate = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate()
   
    var query = "select * from entry where USERNAME = '" + req.params.user +
    "' AND DAY > '" + pastDate + "' and DAY <= '" + curDate + "'";
    index.executeQuery(res, query);
}

// Gets the entried for the week you are in ex. if its tuesday the 10th it will return wednesday 4th - tuesday 10th 
exports.weekEntries = (req, res) => { 
    var today = new Date(); 
    var first = today.getDate() - today.getDay(); 

    today.setDate(first);
    var firstday = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();

    today.setDate(today.getDate() + 6);
    var lastday = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();

    var query = "select * from entry where USERNAME = '" + req.params.user +
    "' AND DAY > '" + firstday + "' and DAY <= '" + lastday + "'";
    index.executeQuery(res, query);
}


// This is the builder for the queries that find totals
function querybuilder(userName, startDate, endDate) {
    var val;
    val ="select sum(amount) from ("+
        "SELECT SUM(e.amount*p.amount) as amount " +
        "from preset_activity AS p, entry AS e " +
        "where  (p.ACTIVITY_ID = e.PRESET_ID) " +
        "and (e.USERNAME = '" + userName + "') " +
        "and (e.day >= '" + startDate + "')and (e.day <= '" + endDate + "') " +
        "UNION " +
        "SELECT SUM(e.amount * a.amount) as amount " +
        "from activity AS a, entry AS e " +
        "where (a.USERNAME = e.USERNAME) and (a.ACTIVITY_ID = e.ACTIVITY_ID) " +
        "and (e.USERNAME = '" + userName + "') " +
        "and (e.day >= '" + startDate + "') and (e.day <= '" + endDate + "')" +
        ") x"
    return val;
}

// total of one day
exports.dayTotal = (req, res) => {
    var today = new Date();
    var curDate = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate()

    var query = querybuilder(req.params.user, curDate, curDate);
    index.executeQuery(res, query);
}

// total of the week period explaied above
exports.weekTotal = (req, res) => {
    var today = new Date(); 
    var first = today.getDate() - today.getDay(); 

    today.setDate(first);
    var firstday = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();

    today.setDate(today.getDate() + 6);
    var lastday = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();

    var query = querybuilder(req.params.user, firstday, lastday);
    index.executeQuery(res, query);
}

// total of the seven day period explaied above
exports.sevenDayTotal = (req, res) => {
    var today = new Date();
    var curDate = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate()
   
    today.setDate(today.getDate() - 7);
    var pastDate = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate()

    var query = querybuilder(req.params.user, pastDate, curDate);
    index.executeQuery(res, query);
}


// The next two queries will use this query builder which is a different than the one above because it will give
// a day by day readout not a total
function dayQueryBuilder(userName, startDate, endDate) {
    var val;
    val = "select sum(amount), day from ( "+
        "SELECT SUM(e.amount*p.amount) as amount, e.day as day " +
        "from preset_activity AS p, entry AS e " +
        "where  (p.ACTIVITY_ID = e.PRESET_ID) " +
        "and (e.USERNAME = '" + userName + "') " +
        "and (e.day > '" + startDate + "')and (e.day <= '" + endDate + "') " +
        "group by e.day " +
        "UNION " +
        "SELECT SUM(e.amount * a.amount) as amount, e.day " +
        "from activity AS a, entry AS e " +
        "where (a.USERNAME = e.USERNAME) and (a.ACTIVITY_ID = e.ACTIVITY_ID) " +
        "and (e.USERNAME = '" + userName + "') " +
        "and (e.day > '" + startDate + "') and (e.day <= '" + endDate + "') " +
        "group by e.day " +
    ") x " +
    "group by day"
    
    return val;
}

//day by day of a week
exports.weekReadout = (req, res) => {
    var today = new Date(); 
    var first = today.getDate() - today.getDay(); 

    today.setDate(first);
    var firstday = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();

    today.setDate(today.getDate() + 6);
    var lastday = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();

    var query = dayQueryBuilder(req.params.user, firstday, lastday);
    index.executeQuery(res, query);
}

// day by day of the seven days
exports.sevenDayReadout = (req, res) => {
    var today = new Date();
    var curDate = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate()
   
    today.setDate(today.getDate() - 7);
    var pastDate = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate()

    var query = dayQueryBuilder(req.params.user, pastDate, curDate);
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