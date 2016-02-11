// app/routes.js
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
module.exports = function(app, passport) {

	// =====================================
	// HOME PAGE (with login links) ========
	// =====================================
	app.get('/', function(req, res) {
		res.render('index.ejs'); // load the index.ejs file
	});

	// =====================================
	// LOGIN ===============================
	// =====================================
	// show the login form
	app.get('/login', function(req, res) {

		// render the page and pass in any flash data if it exists
		res.render('login.ejs', { message: req.flash('loginMessage') });
	});

	// process the login form
	app.post('/login', passport.authenticate('local-login', {
		successRedirect : '/profile', // redirect to the secure profile section
		failureRedirect : '/login', // redirect back to the signup page if there is an error
		failureFlash : true // allow flash messages
	}));

	// =====================================
	// SIGNUP ==============================
	// =====================================
	// show the signup form
	app.get('/signup', function(req, res) {

		// render the page and pass in any flash data if it exists
		res.render('signup.ejs', { message: req.flash('signupMessage') });
	});

	// process the signup form
	app.post('/signup', passport.authenticate('local-signup', {
		successRedirect : '/profile', // redirect to the secure profile section
		failureRedirect : '/signup', // redirect back to the signup page if there is an error
		failureFlash : true // allow flash messages
	}));

	// =====================================
	// PROFILE SECTION =========================
	// =====================================
	// we will want this protected so you have to be logged in to visit
	// we will use route middleware to verify this (the isLoggedIn function)
	app.get('/profile', isLoggedIn, function(req, res) {
		res.render('profile.ejs', {
			user : req.user // get the user out of session and pass to template
		});
	});

	// =====================================
	// LOGOUT ==============================
	// =====================================
	app.get('/logout', function(req, res) {
		req.logout();
		res.redirect('/');
	});


	// =====================================
	// DOORS AND LIGHTS ====================
	// =====================================

	//pass the array of doors or lights, generate code to send to microcontroller(optional create a controller file
	//  to have the code that communicates with the microcontroller)
	app.post('/doors/raise', isLoggedIn, function(req, res) {
		var raiseDoorArray = JSON.parse(req.body.door);
		for (var i = 0, len = raiseDoorArray.length; i < len; i++) {
			if (!raiseDoorQueue.contain(raiseDoorArray[i])) {
				raiseDoorQueue.enqueue(raiseDoorArray[i]);
			}
		}
		doorRaiseControl.doorControl(raiseDoorQueue);
		res.send('POST request to raise the door ');
	});

	app.post('/doors/lower', isLoggedIn, function(req, res) {
		var lowerDoorArray = JSON.parse(req.body.door);
		for (var i = 0, len = lowerDoorArray.length; i < len; i++) {
			if (!lowerDoorQueue.contain(lowerDoorArray[i])) {
				lowerDoorQueue.enqueue(lowerDoorArray[i]);
			}
		}
		doorLowerControl.doorControl(lowerDoorQueue);
		res.send('POST request to lower the door ');
	});


	app.get('/doors/e-stop', isLoggedIn, function(req, res) {
			//send stop request to all microcontrollers
		res.send('GET request to stop all the doors');
	});

	app.post('/lights/raise', isLoggedIn, function(req, res) {
		var raiseLightsArray = JSON.parse(req.body.door);
		for (var i = 0, len = raiseLightsArray.length; i < len; i++) {
			if (!raiseLightQueue.contain(raiseLightsArray[i])) {
				raiseLightQueue.enqueue(raiseLightsArray[i]);
			}
		}
		lightRaiseControl.doorControl(raiseLightQueue);
		res.send('POST request to raise the light ');
	});



	app.post('/lights/lower', isLoggedIn, function(req, res) {
		var lowerLightsArray = JSON.parse(req.body.door);
		for (var i = 0, len = lowerLightsArray.length; i < len; i++) {
		if (!lowerLightQueue.contain(lowerLightArray[i])) {
			lowerLightQueue.enqueue(lowerLightArray[i]);
		}
	}
	lightLowerControl.doorControl(lowerLightQueue);
	res.send('POST request to lower the light ');
});


app.get('/lights/e-stop', isLoggedIn, function(req, res) {
			//send stop request to all microcontrollers
		res.send('GET request to stop all the lights');
	});

};

// route middleware to make sure
function isLoggedIn(req, res, next) {

	// if user is authenticated in the session, carry on
	if (req.isAuthenticated())
		return next();

	// if they aren't redirect them to the home page
	res.redirect('/');
}
