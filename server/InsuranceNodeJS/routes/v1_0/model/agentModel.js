/**
 * Created by WinnerYJ on 2014/7/31.
 */
var schema = {
    id : Number,
    fName : String,
    lName : String,
    diaplayName : String,
    username : String,
    password: String,
    delegateIds: Array
};

var schemaName = "agent";

module.exports = require('../utils/modelUtils').initModel(schema, schemaName);