var constants = require('./constants');
var utils = require('./utils');
var mail = require('nodemailer');
var responseBody = {
  "apiVersion" : "",
  "statusCode" : "",
  "statusMessage" : "",
  "data" : {}
};
var fs = require('fs');

exports.datecompare = function(date1, date2) {
  var strdt1 = date1.replace("-", "/");
  var strdt2 = date2.replace("-", "/");

  var d1 = new Date(strdt1);
  var d2 = new Date(strdt2);
  if (d1 <= d2) {
    return 1;
  } else if (d1 > d2) {
    return -1;
  } /*
     * else{ return 0; }
     */
};

exports.sendCorrectMessage = function(res, data, apiVersion) {
  responseBody.apiVersion = apiVersion;
  responseBody.statusCode = constants.ERROR_CODE_0;
  responseBody.statusMessage = "OK";
  responseBody.data = data;
  var contentType = "";
  if (apiVersion === "v1.0") {
    contentType = "application/com.ibm.mobilecoc.industrial-v1.0+json";
  }
  /*
   * res.writeHead( "200", "OK", { "access-control-allow-origin": "*",
   * "content-type": contentType } );
   */
  res.write(JSON.stringify(responseBody));
  res.end();
};

exports.sendCorrectMessage2 = function(res, data, apiVersion) {
  responseBody.apiVersion = apiVersion;
  responseBody.statusCode = constants.ERROR_CODE_0;
  responseBody.statusMessage = "OK";
  responseBody.data = data;
  var contentType = "";
  if (apiVersion === "v1.0") {
    contentType = "application/com.ibm.mobilecoc.insurance-v1.0+json";
  }
  res.write(JSON.stringify(responseBody));
  res.end();
};

exports.sendErrorMessage2 = function(res, errorMessage, apiVersion) {
  responseBody.apiVersion = apiVersion;
  responseBody.statusCode = constants.ERROR_CODE_1;
  responseBody.statusMessage = errorMessage;
  responseBody.data = {};
  res.write(JSON.stringify(responseBody));
  res.end();
};

exports.sendBusinessErrorMessage = function(res, errorMessage, apiVersion) {
  responseBody.apiVersion = apiVersion;
  responseBody.statusCode = constants.ERROR_CODE_1;
  responseBody.statusMessage = errorMessage;
  responseBody.data = {};
  /*
   * res.writeHead( "200", "OK", { "access-control-allow-origin": "*" } );
   */
  res.write(JSON.stringify(responseBody));
  res.end();
};

exports.sendSystemErrorMessage = function(res, errorMessage, apiVersion) {
  responseBody.apiVersion = apiVersion;
  responseBody.statusCode = constants.ERROR_CODE_2;
  responseBody.statusMessage = errorMessage;
  responseBody.data = {};
  /*
   * res.writeHead( "200", "OK", { "access-control-allow-origin": "*" } );
   */
  res.write(JSON.stringify(responseBody));
  res.end();
};

exports.getAPIVersion = function(req, res) {
  if (req.headers.accept
    && req.headers.accept === constants.API_VERSION_V2_ACCEPT_VALUE) {
    return "v2_0";
  } else {
    return "v1_0";
  }
};

exports.crossDomainSupport = function(req, res) {
  if (req.method.toUpperCase() === "OPTIONS") {
    res.writeHead("204", "No Content", {
      "access-control-allow-origin" : "*",
      "access-control-allow-methods" : "GET, POST, PUT, DELETE, OPTIONS",
      "access-control-allow-headers" : "content-type, accept",
      "access-control-max-age" : 10, // Seconds.
      "content-length" : 0
    });
    return (res.end());
  }
};

exports.sendMail = function(req, res, result, type, apiVersion) {
  // res.set('Content-Type', 'text/plain');
  var email = req.query.email;
  var subject = req.query.userName + "'s password";
  var content = req.query.userName + ', your password is ' + result.password;

  if (type === 'reset') {
    subject = req.query.userName + "'s password has been reset.";
    content = req.query.userName + ', your new password is ' + result.password;
  }
  var smtpTransport = mail.createTransport("SMTP", {
    service : 'Yahoo',
    auth : {
      user : "mobilefirststarterapps@yahoo.com",
      pass : "Passw0rd"
    }
  });
  var mailOptions = {
    from : "mobilefirststarterapps@yahoo.com", // sender address
    to : email, // list of receivers
    subject : subject, // Subject line
    text : content, // plaintext body
    html : content
  // html body
  };
  smtpTransport.sendMail(mailOptions, function(error, response) {
    // res.set('Content-Type', 'text/plain');
    if (error) {
      console.log(error);
      utils.sendErrorMessage2(res, error, apiVersion);
      // res.write('delivery failed');
    } else {
      console.log("Message sent: " + response.message);
      utils.sendCorrectMessage2(res, {}, apiVersion);
      // res.write('Successully delivered!');
    }
    res.end();
  });
};
