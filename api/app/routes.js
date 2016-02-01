// app/routes.js
var Queue = require('../utils/queue');
var doorRaiseControl = require('./controllers/doorRaise');

//queue initialization
var raiseDoorQueue = new Queue();
var lowerDoorQueue = new Queue();
var raiseLightsQueue = new Queue();
var lowerLightsQueue = new Queue();
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
		//for (var i = 0, len = raiseDoorQueue.getLength(); i < len; i++) {
		//	var numberRD = raiseDoorQueue.dequeue (raiseDoorArray[i]);
		//	console.log("door " ,numberRD, " being raised" );
		//}


		res.send('POST request to raise the door ');
	});

	app.post('/doors/lower', isLoggedIn, function(req, res) {
		var lowerDoorArray = JSON.parse(req.body.door);
		for (var i = 0, len = lowerDoorArray.length; i < len; i++) {
			lowerDoorQueue.enqueue (lowerDoorArray[i]);
		}
		for (var i = 0, len = lowerDoorQueue.getLength(); i < len; i++) {
			var numberLD = lowerDoorQueue.dequeue (lowerDoorArray[i]);
			console.log("door " ,numberLD, " being raised" );
		}
		res.send('POST request to lower the doors');
	});

	app.get('/doors/e-stop', isLoggedIn, function(req, res) {
			//send stop request to all microcontrollers
		res.send('GET request to stop all the doors');
	});

	app.post('/lights/raise', isLoggedIn, function(req, res) {
		var raiseLightsArray = JSON.parse(req.body.door);
		for (var i = 0, len = raiseLightsArray.length; i < len; i++) {
			raiseLightsQueue.enqueue (raiseLightsArray[i]);
		}
		for (var i = 0, len = raiseLightsQueue.getLength(); i < len; i++) {
			var numberRL = raiseLightsQueue.dequeue (raiseLightsArray[i]);
			console.log("Light " ,numberRL, " being raised" );
		}
		res.send('POST request to raise the lights');
	});


	app.post('/lights/lower', isLoggedIn, function(req, res) {
		var lowerLightsArray = JSON.parse(req.body.door);
		for (var i = 0, len = lowerLightsArray.length; i < len; i++) {
			lowerLightsQueue.enqueue (lowerLightsArray[i]);
		}
		for (var i = 0, len = lowerLightsQueue.getLength(); i < len; i++) {
			var numberLL = lowerLightsQueue.dequeue (lowerLightsArray[i]);
			console.log("light " ,numberLL, " being raised" );
		}
		res.send('POST request to lower the lights');
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
