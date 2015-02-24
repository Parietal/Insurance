/**
 * Created by WinnerYJ on 2014/7/30.
 */
var modelUtils = require('../utils/modelUtils');
var agentModel = require('../model/agentModel');
var apiVersion = require('../utils/constants').API_VERSION_V1;
var fields = "id fName lName displayName username password delegateIds";

exports.login = function(req, res) {
    modelUtils.query(agentModel, fields, req, res);

};
