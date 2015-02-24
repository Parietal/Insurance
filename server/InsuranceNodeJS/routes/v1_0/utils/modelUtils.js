/*
 * Activity Entity REST Service Implementation
 */
var dbUtils = require('../utils/dbUtils');
var Schema = require('mongoose').Schema;
var apiVersion = require('../utils/constants').API_VERSION_V1;

exports.initModel = function(attrs, schemaName, notAutoIncrement) {
  // Enable pk auto Increment
  var schema = new Schema(attrs);

  !notAutoIncrement && (dbUtils.enableIdAutoIncrement(schema, schemaName));

  // Return constructed model
  return dbUtils.getDBInstance().model(schemaName, schema);
};

// Create one Activity
exports.create = function(Model, req, res) {
  new Model(req.body).save(dbUtils.saveCallback(res, apiVersion));
};

// Find One Activity
exports.findOne = function(Model, fields, req, res) {
  Model.findOne({
    id : req.params.id
  }, fields, dbUtils.findOneCallback(res, apiVersion));
};

// Query Activities
exports.query = function(Model, fields, req, res) {
  Model.find(req.query, fields, dbUtils.queryCallback(res, apiVersion));
};

// Update One Activity
exports.update = function(Model, req, res) {
  delete req.body._id;
  delete req.body.id;
  Model.findOneAndUpdate({
    id : req.params.id
  }, {
    $set : req.body
  }, {
    upsert : false
  }, dbUtils.updateCallback(res, apiVersion));
};

// Delete One Activity
exports.del = function(Model, req, res) {
  Model.findOneAndRemove({
    id : req.params.id
  }, dbUtils.removeCallback(res, apiVersion));
};
