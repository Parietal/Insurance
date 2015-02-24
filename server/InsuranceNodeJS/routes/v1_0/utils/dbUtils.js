/**
 * New node file
 */
var mongoose = require('mongoose');
var Schema = require('mongoose').Schema;
var autoIncrement = require('mongoose-auto-increment');
var utils = require('./utils');
var dbInstance = null;
var fs = require('fs');

exports.getDBInstance = function() {
  return dbInstance;
};

// Enable ID Auto Increment
exports.enableIdAutoIncrement = function(schema, modelName) {
  schema.plugin(autoIncrement.plugin, {
    model : modelName,
    field : 'id',
    startAt : 100
  });
};

exports.initMongoDBInstance = function(success) {
  var mongo;
  if (process.env.VCAP_SERVICES) {
    var env = JSON.parse(process.env.VCAP_SERVICES);
    console.log("env:" + env);
    console.log("env str:" + JSON.stringify(env));
    mongo = env['mongodb-2.2'][0].credentials;
  } else {
    mongo = {
      "hostname" : "ds035760.mongolab.com",
      "port" : 35760,
      "username" : "IbmCloud_ebppb6a5_r2b7pph1_kjvvurr9",
      "password" : "hRU2PsJNEnBjM66Lxo2vwEOJl2o0G-co",
      "name" : "MongoLab-InsuranceAPI",
      "db" : "IbmCloud_ebppb6a5_r2b7pph1",
      "url" : "mongodb://IbmCloud_ebppb6a5_r2b7pph1_kjvvurr9:hRU2PsJNEnBjM66Lxo2vwEOJl2o0G-co@ds035760.mongolab.com:35760/IbmCloud_ebppb6a5_r2b7pph1"
    };
//    mongo.url = "mongodb://IbmCloud_ebppb6a5_r2b7pph1_kjvvurr9:hRU2PsJNEnBjM66Lxo2vwEOJl2o0G-co@ds035760.mongolab.com:35760/IbmCloud_ebppb6a5_r2b7pph1";
    mongo.url = "mongodb://localhost:27017/insurance";
  }

  dbInstance = mongoose.createConnection(mongo.url);
  dbInstance.on('error', function() {
    console.log("Connection is refused");
  });
  autoIncrement.initialize(dbInstance);
  dbInstance.once('open', function() {
    success();
  });
};

// Save Operation Callback function
exports.saveCallback = function(res, apiVersion) {
  return function(err, entity) {
    if (!err) {
      utils.sendCorrectMessage(res, {
        id : entity.id
      }, apiVersion);
    } else {
      utils.sendSystemErrorMessage(res, err.stack, apiVersion);
    }
  };
};

// Update Operation Callback function
exports.updateCallback = function(res, apiVersion) {
  return function(err, entity) {
    if (!err) {
      if (entity) {
        utils.sendCorrectMessage(res, {}, apiVersion);
      } else {
        utils.sendSystemErrorMessage(res, "Could not Find", apiVersion);
      }
    } else {
      utils.sendSystemErrorMessage(res, err.stack, apiVersion);
    }
  };
};

// Update Operation Callback function
exports.removeCallback = function(res, apiVersion) {
  return function(err, entity) {
    if (!err) {
      if (entity) {
        utils.sendCorrectMessage(res, {}, apiVersion);
      } else {
        utils.sendSystemErrorMessage(res, "Could not Find", apiVersion);
      }
    } else {
      utils.sendSystemErrorMessage(res, err.stack, apiVersion);
    }
  };
};

// FindOne Operation Callback function
exports.findOneCallback = function(res, apiVersion) {
  return function(err, entity) {
    if (!err) {
      utils.sendCorrectMessage(res, entity, apiVersion);
    } else {
      utils.sendSystemErrorMessage(res, err.stack, apiVersion);
    }
  };
};

// Query Operation Callback function
exports.queryCallback = function(res, apiVersion) {
  return function(err, entities) {
    if (!err) {
      utils.sendCorrectMessage(res, entities, apiVersion);
    } else {
      utils.sendSystemErrorMessage(res, err.stack, apiVersion);
    }
  };
};

// Reset all data
exports.initData = function(req, res) {

  function loadDataToDb(datas, index) {
    if (index >= datas.length) {
      res.send("Init success.");
      return;
    }
    var data = datas[index];
    var jsonName = data.json;
    // Load model
    var Model = require('../model/' + data.model);
    // Remove existed document
    Model.collection.drop();

    fs.readFile('./routes/v1_0/data/' + jsonName + '.json', function(err, doc) {
      var failMsg = 'Init ' + jsonName + ' Entity Failed';
      if (!err) {
        Model.collection.insert(JSON.parse(doc), {
          w : 1
        }, function(err, result) {
          if (err) {
            res.send(failMsg);
          } else {
            loadDataToDb(datas, index + 1);
          }
        });
      } else {
        res.send(failMsg);
      }
    });
  }

  var datas = [ {
    model : "agentModel",
    json : "agent"
  }, {
    model : "delegateModel",
    json : "delegate"
  } ];
  
  loadDataToDb(datas, 0);
};
