// app/routes.js
var User = require('./models/user'); // get the mongoose model
var Door = require('./models/door');
var jwt = require('jwt-simple');
var config = require('../config/database'); // get db config file
var Queue = require('../utils/queue');
var doorRaiseControl = require('./controllers/doorRaise');
var doorLowerControl = require('./controllers/doorLower');
var lightRaiseControl = require('./controllers/lightRaise');
var lightLowerControl = require('./controllers/lightLower');
//queue initialization
var raiseDoorQueue = new Queue();
var lowerDoorQueue = new Queue();
var raiseLightQueue = new Queue();
var lowerLightQueue = new Queue();
var logger   = require("logger");

module.exports = function(app, passport) {



	var door1 = new Door({
					number: 1,
					state: 'stopped',
					position: 'closed',
					ip: '10.10.10.1'
				});
	door1.save(function (err) {
		if (err) {// ...
		} else {
			console.log('door 1 created');
		}

	});

	var door2 = new Door({ number: 2, state: 'stopped', position: 'closed', ip: '10.10.10.2' });
	door2.save(function (err) {
		if (err) {// ...
		} else {
			console.log('door 2 created');
		}
	});

	var door3 = new Door({ number: 3, state: 'stopped', position: 'closed', ip: '10.10.10.3' });
	door3.save(function (err) {
		if (err) { // ...
		} else {
			console.log('door 3 created');
		}
	});

	// =====================================
	// HOME PAGE (with login links) ========
	// =====================================
	app.get('/', function(req, res) {
		res.render('forbidden'); // load the index.ejs file
	});

	// =====================================
	// LOGIN ===============================
	// =====================================
	//// show the login form
	//app.get('/login', function(req, res) {
    //
	//	// render the page and pass in any flash data if it exists
	//	res.render('login.ejs', { message: req.flash('loginMessage') });
	//});

	//// process the login form
	//app.post('/login', passport.authenticate('local-login', {
	//	successRedirect : '/profile', // redirect to the secure profile section
	//	failureRedirect : '/login', // redirect back to the signup page if there is an error
	//	failureFlash : true // allow flash messages
	//}));

	// =====================================
	// SIGNUP ==============================
	// =====================================
	// show the signup form
	//app.get('/signup', function(req, res) {
    //
	//	// render the page and pass in any flash data if it exists
	//	res.render('signup.ejs', { message: req.flash('signupMessage') });
	//});
    //
	//// process the signup form
	//app.post('/signup', passport.authenticate('local-signup', {
	//	successRedirect : '/profile', // redirect to the secure profile section
	//	failureRedirect : '/signup', // redirect back to the signup page if there is an error
	//	failureFlash : true // allow flash messages
	//}));

	// =====================================
	// PROFILE SECTION =========================
	// =====================================
	// we will want this protected so you have to be logged in to visit
	// we will use route middleware to verify this (the isLoggedIn function)
	//app.get('/profile', isLoggedIn, function(req, res) {
	//	res.render('profile.ejs', {
	//		user : req.user // get the user out of session and pass to template
	//	});
	//});
    //
	//// =====================================
	//// LOGOUT ==============================
	//// =====================================
	//app.get('/logout', function(req, res) {
	//	req.logout();
	//	res.redirect('/');
	//});
       //=======================================
	   //alan Login function ===================
	   //=======================================

	app.post('/signup', function(req, res) {
		if (!req.body.email || !req.body.password) {
			res.json({succes: false, msg: 'Please pass email and password.'});
		} else {
			var newUser = new User({
				email: req.body.email,
				password: req.body.password
			});
			newUser.save(function(err) {
				if (err) {
					res.json({succes: false, msg: 'User email already exists.'});
				} else {
					res.json({succes: true, msg: 'Successful created user!'});
					logger.info('Username : ' +  email + ' created');
				}
			});
		}
	});

	app.post('/authenticate', function(req, res) {
		User.findOne({
			email: req.body.email
		}, function(err, user) {
			if (err) throw err;

			if (!user) {
				res.send({success: false, msg: 'Authentication failed. User email not found.'});
			} else {
				user.comparePassword(req.body.password, function(err, isMatch) {
					if (isMatch && !err) {
						var token = jwt.encode(user, config.secret);
						res.json({success: true, token: 'JWT ' + token});
						logger.info('Username : ' +  user + ' logged in');
					} else {
						res.send({success: false, msg: 'Authentication failed. Wrong password.'});
					}
				});
			}
		});
	});

	app.get('/memberinfo', passport.authenticate('jwt', {session: false}), function(req, res) {
		var token = getToken(req.headers);
		if (token) {
			var decoded = jwt.decode(token, config.secret);
			User.findOne({
				email: decoded.email
			}, function(err, user) {
				if (err) throw err;

				if (!user) {
					return res.status(403).send({success: false, msg: 'Authentication failed. User not found.'});
				} else {
					return res.json({success: true, msg: 'Welcome in the member area ' + user.email + '!'});
				}
			});
		} else {
			return res.status(403).send({success: false, msg: 'No token provided.'});
		}
	});

	getToken = function(headers) {
		if (headers && headers.authorization) {
			var parted = headers.authorization.split(' ');
			if (parted.length === 2) {
				return parted[1];
			} else {
				return null;
			}
		} else {
			return null;
		}
	};

	// =====================================
	// DOORS AND LIGHTS ====================
	// =====================================

	//pass the array of doors or lights, generate code to send to microcontroller(optional create a controller file
	//  to have the code that communicates with the microcontroller)
	app.post('/doors/raise', function(req, res) {
		//var raiseDoorArray = JSON.parse(req.body.door);
		//for (var i = 0, len = raiseDoorArray.length; i < len; i++) {
		//	if (!raiseDoorQueue.contain(raiseDoorArray[i])) {
		//		raiseDoorQueue.enqueue(raiseDoorArray[i]);
		//	}
		//}
		//doorRaiseControl.doorControl(raiseDoorQueue);
		var token = getToken(req.headers);
		if (token) {
			var decoded = jwt.decode(token, config.secret);
			User.findOne({
				email: decoded.email
			}, function(err, user) {
				if (err) throw err;

				if (!user) {
					return res.status(403).send({success: false, msg: 'Authentication failed. User not found.'});
				} else {
					doorRaiseControl.doorControl(JSON.parse(req.body.door));
					logger.info('Door 1 requested to be raised.');
					return res.json({success: true, msg: 'POST request to raise the door'});
				}
			});
		} else {
			return res.status(403).send({success: false, msg: 'No token provided.'});
		}
		//doorRaiseControl.doorControl(JSON.parse(req.body.door));
		//doorRaiseControl.doorControl(JSON.parse(req.body.door));
		//res.send('POST request to raise the door');
	});

	app.post('/doors/lower', function(req, res) {
		//var lowerDoorArray = JSON.parse(req.body.door);
		//for (var i = 0, len = lowerDoorArray.length; i < len; i++) {
		//	if (!lowerDoorQueue.contain(lowerDoorArray[i])) {
		//		lowerDoorQueue.enqueue(lowerDoorArray[i]);
		//	}
		//}
		//doorLowerControl.doorControl(lowerDoorQueue);

		var token = getToken(req.headers);
		if (token) {
			var decoded = jwt.decode(token, config.secret);
			User.findOne({
				email: decoded.email
			}, function(err, user) {
				if (err) throw err;

				if (!user) {
					return res.status(403).send({success: false, msg: 'Authentication failed. User not found.'});
				} else {
					doorLowerControl.doorControl(JSON.parse(req.body.door));
					logger.info('Door 1 requested to be lowered.');
					return res.json({success: true, msg: 'POST request to lower the door'});
				}
			});
		} else {
			logger.info('error on request.');
			return res.status(403).send({success: false, msg: 'No token provided.'});
		}
		//doorLowerControl.doorControl(JSON.parse(req.body.door));
		//winston.log('info', 'Door 1 requested to be lowered.');
		//res.send('POST request to lower the door');
	});


	app.get('/doors/e-stop', function(req, res) {
			//send stop request to all microcontrollers
		logger.info('Emergency stop requested for doors.');
		res.send('GET request to stop all the doors');
	});

	app.post('/lights/raise', function(req, res) {
		//var raiseLightsArray = JSON.parse(req.body.light);
		//for (var i = 0, len = raiseLightsArray.length; i < len; i++) {
		//	if (!raiseLightQueue.contain(raiseLightsArray[i])) {
		//		raiseLightQueue.enqueue(raiseLightsArray[i]);
		//	}
		//}
		//lightRaiseControl.doorControl(raiseLightQueue);
		var token = getToken(req.headers);
		if (token) {
			var decoded = jwt.decode(token, config.secret);
			User.findOne({
				email: decoded.email
			}, function(err, user) {
				if (err) throw err;

				if (!user) {
					return res.status(403).send({success: false, msg: 'Authentication failed. User not found.'});
				} else {
					lightRaiseControl.doorControl(JSON.parse(req.body.light));
					logger.info('Light 1 requested to be raised.');
					return res.json({success: true, msg: 'POST request to raise the light'});
				}
			});
		} else {
			return res.status(403).send({success: false, msg: 'No token provided.'});
		}
		//lightRaiseControl.doorControl(JSON.parse(req.body.light));
		//winston.log('info', 'Light 1 requested to be raised.');
		//res.send('POST request to raise the light ');
	});



	app.post('/lights/lower', function(req, res) {
	//	var lowerLightsArray = JSON.parse(req.body.light);
	//	for (var i = 0, len = lowerLightsArray.length; i < len; i++) {
	//	if (!lowerLightQueue.contain(lowerLightArray[i])) {
	//		lowerLightQueue.enqueue(lowerLightArray[i]);
	//	}
	//}
	//lightLowerControl.doorControl(lowerLightQueue);
		var token = getToken(req.headers);
		if (token) {
			var decoded = jwt.decode(token, config.secret);
			User.findOne({
				email: decoded.email
			}, function(err, user) {
				if (err) throw err;

				if (!user) {
					return res.status(403).send({success: false, msg: 'Authentication failed. User not found.'});
				} else {
					lightLowerControl.doorControl(JSON.parse(req.body.light));
					logger.info('Light 1 requested to be lowered.');
					return res.json({success: true, msg: 'POST request to lower the light'});
				}
			});
		} else {
			return res.status(403).send({success: false, msg: 'No token provided.'});
		}
		//lightLowerControl.doorControl(JSON.parse(req.body.light));
		//winston.log('info', 'Light 1 requested to be lowered.');
	//res.send('POST request to lower the light ');
});


app.get('/lights/e-stop', function(req, res) {
			//send stop request to all microcontrollers
	logger.info(' Emergency stop requested for Lights.');
		res.send('GET request to stop all the lights');
	});

};

// route middleware to make sure
//function isLoggedIn(req, res, next) {
//
//	// if user is authenticated in the session, carry on
//	if (req.isAuthenticated())
//		return next();
//
//	// if they aren't redirect them to the home page
//	res.redirect('/');
//}
