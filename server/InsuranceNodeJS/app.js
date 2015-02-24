var express = require('express');
var apiVersion = "v1_0";
var utils = require('./routes/' + apiVersion + '/utils/utils');
var dbUtils = require('./routes/' + apiVersion + '/utils/dbUtils');
var host = (process.env.VCAP_APP_HOST || 'localhost');
var port = (process.env.VCAP_APP_PORT || 3000);
var app = express();

app.configure(function () {
    app.use(express.bodyParser());
    app.use(express.errorHandler());
    app.use(express.methodOverride());

    app.use(function (req, res, next) {
        apiVersion = utils.getAPIVersion(req, res);

        app.get('/datareset', dbUtils.initData);

        var agent = require('./routes/' + apiVersion + '/api/agent');

        //agent api
        app.get('/agents', agent.login);

        next();
    });

    app.use(app.router);
});

// init mongodb and start listen
dbUtils.initMongoDBInstance(function () {
    // mongoDBUtils.initData();
    app.listen(port, host);
    console.log('App started on port ' + port);
});
