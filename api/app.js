var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var mongoose = require('mongoose');
var bcrypt = require('bcrypt');
var basicAuth = require('basic-auth');


var index = require('./routes/index');
var users = require('./routes/users');
var doors = require('./routes/doors');
var lights = require('./routes/lights');
var microcontrollers = require('./routes/microcontrollers');
var sensors = require('./routes/sensors');

var app = express();

require('./models/doors');
require('./models/lights');
require('./models/microcontrollers');
require('./models/sensors');
require('./models/users');
var	doorsController = require('./controllers/doors');
var	lightsController = require('./controllers/lights');
var	usersController = require('./controllers/users');
var	microcontrollersController = require('./controllers/microcontrollers');
var	sensorsController = require('./controllers/sensors');

mongoose.connect('mongodb://localhost/ocity');


// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(require('less-middleware')(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', index);
//app.use('/users', doors);
//app.use('/users', lights);
//app.use('/users', microcontrollers);
//app.use('/users', sensors);


app.use('/users', users);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.render('error', {
    message: err.message,
    error: {}
  });
});


module.exports = app;
