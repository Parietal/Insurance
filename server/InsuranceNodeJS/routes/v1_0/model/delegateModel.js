/**
 * Created by WinnerYJ on 2014/7/31.
 */
var schema = {
    id : Number,
    fName : String,
    lName : String,
    diaplayName : String
};

var schemaName = "delegate";

module.exports = require('../utils/modelUtils').initModel(schema, schemaName);