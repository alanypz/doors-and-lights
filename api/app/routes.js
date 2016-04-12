// app/routes.js
var User = require('./models/user'); // get the mongoose model
var Door = require('./models/door');
var Light = require('./models/light');
var jwt = require('jwt-simple');
var config = require('../config/database'); // get db config file
var Queue = require('../utils/queue');
var doorRaiseControl = require('./controllers/doorRaise');
var doorLowerControl = require('./controllers/doorLower');
var lightRaiseControl = require('./controllers/lightRaise');
var lightLowerControl = require('./controllers/lightLower');
var doorStopControl = require('./controllers/doorStop');
var doorEStopControl = require('./controllers/doorEStop');

//queue initialization
var raiseDoorQueue = new Queue();
var lowerDoorQueue = new Queue();
var raiseLightQueue = new Queue();
var lowerLightQueue = new Queue();


var logger = require("logger");

module.exports = function (app, passport) {


    var door1 = new Door({number: 1, state: 'stopped', position: 'lowered', ip: '192.168.43.77' });
    door1.save(function (err) {
        if (err) {// ...
        } else {
            console.log('door 1 created');
        }
    });

    var door2 = new Door({number: 2, state: 'stopped', position: 'lowered', ip: '10.10.10.2'});
    door2.save(function (err) {
        if (err) {
        } else {
            console.log('door 2 created');
        }
    });

    var door3 = new Door({number: 3, state: 'stopped', position: 'lowered', ip: '10.10.10.3'});
    door3.save(function (err) {
        if (err) {
        } else {
            console.log('door 3 created');
        }
    });
    var door4 = new Door({number: 4, state: 'stopped', position: 'lowered', ip: '10.10.10.4' });
    door4.save(function (err) {
        if (err) {// ...
        } else {
            console.log('door 4 created');
        }
    });

    var door5 = new Door({number: 5, state: 'stopped', position: 'lowered', ip: '10.10.10.5'});
    door5.save(function (err) {
        if (err) {
        } else {
            console.log('door 5 created');
        }
    });

    var door6 = new Door({number: 6, state: 'stopped', position: 'lowered', ip: '10.10.10.6'});
    door6.save(function (err) {
        if (err) {
        } else {
            console.log('door 6 created');
        }
    });

    var door7 = new Door({number: 7, state: 'stopped', position: 'lowered', ip: '10.10.10.7' });
    door7.save(function (err) {
        if (err) {// ...
        } else {
            console.log('door 7 created');
        }
    });

    var door8 = new Door({number: 8, state: 'stopped', position: 'lowered', ip: '10.10.10.8'});
    door8.save(function (err) {
        if (err) {
        } else {
            console.log('door 8 created');
        }
    });

    var door9 = new Door({number: 9, state: 'stopped', position: 'lowered', ip: '10.10.10.9'});
    door9.save(function (err) {
        if (err) {
        } else {
            console.log('door 9 created');
        }
    });
    var door10 = new Door({number: 10, state: 'stopped', position: 'lowered', ip: '10.10.10.10' });
    door10.save(function (err) {
        if (err) {// ...
        } else {
            console.log('door 10 created');
        }
    });

    var door11 = new Door({number: 11, state: 'stopped', position: 'lowered', ip: '10.10.10.11'});
    door11.save(function (err) {
        if (err) {
        } else {
            console.log('door 11 created');
        }
    });

    var door12 = new Door({number: 12, state: 'stopped', position: 'lowered', ip: '10.10.10.12'});
    door12.save(function (err) {
        if (err) {
        } else {
            console.log('door 12 created');
        }
    });

    var door13 = new Door({number: 13, state: 'stopped', position: 'lowered', ip: '10.10.10.13' });
    door13.save(function (err) {
        if (err) {// ...
        } else {
            console.log('door 13 created');
        }
    });

    var door14 = new Door({number: 14, state: 'stopped', position: 'lowered', ip: '10.10.10.14'});
    door14.save(function (err) {
        if (err) {
        } else {
            console.log('door 14 created');
        }
    });

    var door15 = new Door({number: 15, state: 'stopped', position: 'lowered', ip: '10.10.10.15'});
    door15.save(function (err) {
        if (err) {
        } else {
            console.log('door 15 created');
        }
    });
    var door16 = new Door({number: 16, state: 'stopped', position: 'lowered', ip: '10.10.10.16' });
    door16.save(function (err) {
        if (err) {// ...
        } else {
            console.log('door 16 created');
        }
    });

    var door17 = new Door({number: 17, state: 'stopped', position: 'lowered', ip: '10.10.10.17'});
    door17.save(function (err) {
        if (err) {
        } else {
            console.log('door 17 created');
        }
    });

    var door18 = new Door({number: 18, state: 'stopped', position: 'lowered', ip: '10.10.10.18'});
    door18.save(function (err) {
        if (err) {
        } else {
            console.log('door 18 created');
        }
    });

    var door19 = new Door({number: 19, state: 'stopped', position: 'lowered', ip: '10.10.10.19' });
    door19.save(function (err) {
        if (err) {// ...
        } else {
            console.log('door 19 created');
        }
    });

    var door20 = new Door({number: 20, state: 'stopped', position: 'lowered', ip: '10.10.10.20'});
    door20.save(function (err) {
        if (err) {
        } else {
            console.log('door 20 created');
        }
    });

    var door21 = new Door({number: 21, state: 'stopped', position: 'lowered', ip: '10.10.10.21'});
    door21.save(function (err) {
        if (err) {
        } else {
            console.log('door 21 created');
        }
    });
    var door22 = new Door({number: 22, state: 'stopped', position: 'lowered', ip: '10.10.10.22' });
    door22.save(function (err) {
        if (err) {// ...
        } else {
            console.log('door 22 created');
        }
    });

    var door23 = new Door({number: 23, state: 'stopped', position: 'lowered', ip: '10.10.10.23'});
    door23.save(function (err) {
        if (err) {
        } else {
            console.log('door 23 created');
        }
    });

    var door24 = new Door({number: 24, state: 'stopped', position: 'lowered', ip: '10.10.10.24'});
    door24.save(function (err) {
        if (err) {
        } else {
            console.log('door 24 created');
        }
    });

    var door25 = new Door({number: 25, state: 'stopped', position: 'lowered', ip: '10.10.10.25' });
    door25.save(function (err) {
        if (err) {// ...
        } else {
            console.log('door 25 created');
        }
    });

    var door26 = new Door({number: 26, state: 'stopped', position: 'lowered', ip: '10.10.10.26'});
    door26.save(function (err) {
        if (err) {
        } else {
            console.log('door 26 created');
        }
    });

    var door27 = new Door({number: 27, state: 'stopped', position: 'lowered', ip: '10.10.10.27'});
    door27.save(function (err) {
        if (err) {
        } else {
            console.log('door 27 created');
        }
    });
    var door28 = new Door({number: 28, state: 'stopped', position: 'lowered', ip: '10.10.10.28' });
    door28.save(function (err) {
        if (err) {// ...
        } else {
            console.log('door 28 created');
        }
    });

    var door29 = new Door({number: 29, state: 'stopped', position: 'lowered', ip: '10.10.10.29'});
    door29.save(function (err) {
        if (err) {
        } else {
            console.log('door 29 created');
        }
    });

    var door30 = new Door({number: 30, state: 'stopped', position: 'lowered', ip: '10.10.10.30'});
    door30.save(function (err) {
        if (err) {
        } else {
            console.log('door 30 created');
        }
    });

    var light1 = new Light({ number: 1, state: 'stopped', position: 'raised', ip: '10.10.20.1' });
    light1.save(function (err) {
        if (err) {
        } else {
            console.log('light 1 created');
        }
    });

    var light2 = new Light({number: 2, state: 'stopped', position: 'raised', ip: '10.10.20.2'});
    light2.save(function (err) {
        if (err) {
        } else {
            console.log('light 2 created');
        }
    });

    var light3 = new Light({number: 3, state: 'stopped', position: 'raised', ip: '10.10.20.3'});
    light3.save(function (err) {
        if (err) {
        } else {
            console.log('light 3 created');
        }
    });

    var light4 = new Light({number: 4, state: 'stopped', position: 'raised', ip: '10.10.20.4' });
    light4.save(function (err) {
        if (err) {// ...
        } else {
            console.log('light 4 created');
        }
    });

    var light5 = new Light({number: 5, state: 'stopped', position: 'raised', ip: '10.10.20.5'});
    light5.save(function (err) {
        if (err) {
        } else {
            console.log('light 5 created');
        }
    });

    var light6 = new Light({number: 6, state: 'stopped', position: 'raised', ip: '10.10.20.6'});
    light6.save(function (err) {
        if (err) {
        } else {
            console.log('light 6 created');
        }
    });

    var light7 = new Light({number: 7, state: 'stopped', position: 'raised', ip: '10.10.20.7' });
    light7.save(function (err) {
        if (err) {// ...
        } else {
            console.log('light 7 created');
        }
    });

    var light8 = new Light({number: 8, state: 'stopped', position: 'raised', ip: '10.10.20.8'});
    light8.save(function (err) {
        if (err) {
        } else {
            console.log('light 8 created');
        }
    });

    var light9 = new Light({number: 9, state: 'stopped', position: 'raised', ip: '10.10.20.9'});
    light9.save(function (err) {
        if (err) {
        } else {
            console.log('light 9 created');
        }
    });
    var light10 = new Light({number: 10, state: 'stopped', position: 'raised', ip: '10.10.20.10' });
    light10.save(function (err) {
        if (err) {// ...
        } else {
            console.log('light 10 created');
        }
    });

    var light11 = new Light({number: 11, state: 'stopped', position: 'raised', ip: '10.10.20.11'});
    light11.save(function (err) {
        if (err) {
        } else {
            console.log('light 11 created');
        }
    });

    var light12 = new Light({number: 12, state: 'stopped', position: 'raised', ip: '10.10.20.12'});
    light12.save(function (err) {
        if (err) {
        } else {
            console.log('light 12 created');
        }
    });

    var light13 = new Light({number: 13, state: 'stopped', position: 'raised', ip: '10.10.20.13' });
    light13.save(function (err) {
        if (err) {// ...
        } else {
            console.log('light 13 created');
        }
    });

    var light14 = new Light({number: 14, state: 'stopped', position: 'raised', ip: '10.10.20.14'});
    light14.save(function (err) {
        if (err) {
        } else {
            console.log('light 14 created');
        }
    });

    var light15 = new Light({number: 15, state: 'stopped', position: 'raised', ip: '10.10.20.15'});
    light15.save(function (err) {
        if (err) {
        } else {
            console.log('light 15 created');
        }
    });
    var light16 = new Light({number: 16, state: 'stopped', position: 'raised', ip: '10.10.20.16' });
    light16.save(function (err) {
        if (err) {// ...
        } else {
            console.log('light 16 created');
        }
    });

    var light17 = new Light({number: 17, state: 'stopped', position: 'raised', ip: '10.10.20.17'});
    light17.save(function (err) {
        if (err) {
        } else {
            console.log('light 17 created');
        }
    });

    var light18 = new Light({number: 18, state: 'stopped', position: 'raised', ip: '10.10.20.18'});
    light18.save(function (err) {
        if (err) {
        } else {
            console.log('light 18 created');
        }
    });

    var light19 = new Light({number: 19, state: 'stopped', position: 'raised', ip: '10.10.20.19' });
    light19.save(function (err) {
        if (err) {// ...
        } else {
            console.log('light 19 created');
        }
    });

    var light20 = new Light({number: 20, state: 'stopped', position: 'raised', ip: '10.10.20.20'});
    light20.save(function (err) {
        if (err) {
        } else {
            console.log('light 20 created');
        }
    });

    var light21 = new Light({number: 21, state: 'stopped', position: 'raised', ip: '10.10.20.21'});
    light21.save(function (err) {
        if (err) {
        } else {
            console.log('light 21 created');
        }
    });
    var light22 = new Light({number: 22, state: 'stopped', position: 'raised', ip: '10.10.20.22' });
    light22.save(function (err) {
        if (err) {// ...
        } else {
            console.log('light 22 created');
        }
    });

    var light23 = new Light({number: 23, state: 'stopped', position: 'raised', ip: '10.10.20.23'});
    light23.save(function (err) {
        if (err) {
        } else {
            console.log('light 23 created');
        }
    });

    var light24 = new Light({number: 24, state: 'stopped', position: 'raised', ip: '10.10.20.24'});
    light24.save(function (err) {
        if (err) {
        } else {
            console.log('light 24 created');
        }
    });

    var light25 = new Light({number: 25, state: 'stopped', position: 'raised', ip: '10.10.20.25' });
    light25.save(function (err) {
        if (err) {// ...
        } else {
            console.log('light 25 created');
        }
    });

    var light26 = new Light({number: 26, state: 'stopped', position: 'raised', ip: '10.10.20.26'});
    light26.save(function (err) {
        if (err) {
        } else {
            console.log('light 26 created');
        }
    });

    var light27 = new Light({number: 27, state: 'stopped', position: 'raised', ip: '10.10.20.27'});
    light27.save(function (err) {
        if (err) {
        } else {
            console.log('light 27 created');
        }
    });
    var light28 = new Light({number: 28, state: 'stopped', position: 'raised', ip: '10.10.20.28' });
    light28.save(function (err) {
        if (err) {// ...
        } else {
            console.log('light 28 created');
        }
    });

    var light29 = new Light({number: 29, state: 'stopped', position: 'raised', ip: '10.10.20.29'});
    light29.save(function (err) {
        if (err) {
        } else {
            console.log('light 29 created');
        }
    });

    var light30 = new Light({number: 30, state: 'stopped', position: 'raised', ip: '10.10.20.30'});
    light30.save(function (err) {
        if (err) {
        } else {
            console.log('light 30 created');
        }
    });

    // =====================================
    // HOME PAGE (with login links) ========
    // =====================================
    app.get('/', function (req, res) {
        res.render('forbidden'); // load the index.ejs file
    });


    //=======================================
    //alan Login function ===================
    //=======================================

    app.post('/signup', function (req, res) {
        if (!req.body.email || !req.body.password) {
            res.json({succes: false, msg: 'Please pass email and password.'});
        } else {
            var newUser = new User({
                email: req.body.email,
                password: req.body.password
            });
            newUser.save(function (err) {
                if (err) {
                    res.json({succes: false, msg: 'User email already exists.'});
                } else {
                    res.json({succes: true, msg: 'Successful created user!'});
                    logger.info('Username : ' + email + ' created');
                }
            });
        }
    });

    app.post('/authenticate', function (req, res) {
        User.findOne({
            email: req.body.email
        }, function (err, user) {
            if (err) throw err;

            if (!user) {
                res.send({success: false, msg: 'Authentication failed. User email not found.'});
            } else {
                user.comparePassword(req.body.password, function (err, isMatch) {
                    if (isMatch && !err) {
                        var token = jwt.encode(user, config.secret);
                        res.json({success: true, token: 'JWT ' + token});
                        console.log('Username : ' + user + ' logged in');
                        logger.info('Username : ' + user + ' logged in');
                    } else {
                        res.send({success: false, msg: 'Authentication failed. Wrong password.'});
                    }
                });
            }
        });
    });

    app.get('/memberinfo', passport.authenticate('jwt', {session: false}), function (req, res) {
        var token = getToken(req.headers);
        if (token) {
            var decoded = jwt.decode(token, config.secret);
            User.findOne({
                email: decoded.email
            }, function (err, user) {
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


    // =====================================
    // DOORS AND LIGHTS ====================
    // =====================================

    //pass the array of doors or lights, generate code to send to microcontroller(optional create a controller file
    //  to have the code that communicates with the microcontroller)
    app.post('/doors/raise', function (req, res) {
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
            }, function (err, user) {
                if (err) throw err;

                if (!user) {
                    return res.status(403).send({success: false, msg: 'Authentication failed. User not found.'});
                } else {
                    doorRaiseControl.doorControl(JSON.parse(req.body.door));
                    logger.info('Door ' + req.body.door + ' requested to be raised.');
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

    app.post('/doors/lower', function (req, res) {
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
            }, function (err, user) {
                if (err) throw err;

                if (!user) {
                    return res.status(403).send({success: false, msg: 'Authentication failed. User not found.'});
                } else {
                    doorLowerControl.doorControl(JSON.parse(req.body.door));
                    logger.info('Door ' + req.body.door + ' requested to be lowered.');
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


    app.post('/doors/stop', function (req, res) {
        //stop request from microcontrollers
        var token = getToken(req.headers);
        if (token) {
            var decoded = jwt.decode(token, config.secret);
            User.findOne({
                email: decoded.email
            }, function (err, user) {
                if (err) throw err;

                if (!user) {
                    return res.status(403).send({success: false, msg: 'Authentication failed. User not found.'});
                } else {
                    doorStopControl.doorControl(JSON.parse(req.body.door));
                    logger.info('Door ' + req.body.door + ' requested to be stopped.');
                    return res.json({success: true, msg: 'POST request to stop the door'});
                }
            });
        } else {
            logger.info('error on request.');
            return res.status(403).send({success: false, msg: 'No token provided.'});
        }
    });

    app.get('doors/e-stop', function (req, res) {
        //send stop request to all microcontrollers
        var token = getToken(req.headers);
        if (token) {
            var decoded = jwt.decode(token, config.secret);
            User.findOne({
                email: decoded.email
            }, function (err, user) {
                if (err) throw err;

                if (!user) {
                    return res.status(403).send({success: false, msg: 'Authentication failed. User not found.'});
                } else {
                    doorEStopControl.doorControl();
                    logger.info('All doors being requested to be stopped.');
                    return res.json({success: true, msg: 'GET request to stop all door'});
                }
            });
        } else {
            logger.info('error on request.');
            return res.status(403).send({success: false, msg: 'No token provided.'});
        }
    });

    app.get('doors/update', function(req, res) {
        //update database after completion of microcontroller action
        var ip = req.ip;
        var status = req.query.status;
        doorEStopControl.doorControl(ip, status);
        logger.info('door is being updated stopped.');
        res.json({success: true, msg: 'GET request from microcontroller to update the database'});
    });

    app.post('/lights/raise', function (req, res) {
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
            }, function (err, user) {
                if (err) throw err;

                if (!user) {
                    return res.status(403).send({success: false, msg: 'Authentication failed. User not found.'});
                } else {
                    lightRaiseControl.lightControl(JSON.parse(req.body.light));
                    logger.info('Light ' + req.body.light + ' requested to be raised.');
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


    app.post('/lights/lower', function (req, res) {
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
            }, function (err, user) {
                if (err) throw err;

                if (!user) {
                    return res.status(403).send({success: false, msg: 'Authentication failed. User not found.'});
                } else {
                    lightLowerControl.lightControl(JSON.parse(req.body.light));
                    logger.info('Light ' + req.body.light + ' requested to be lowered.');
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


    app.get('/lights/e-stop', function (req, res) {
        //send stop request to all microcontrollers
        logger.info(' Emergency stop requested for Lights.');
        res.send('GET request to stop all the lights');
    });

    app.get('/status/light', function(req, res) {
       //get data from database
        var token = getToken(req.headers);
        if (token) {
            var decoded = jwt.decode(token, config.secret);
            User.findOne({
                email: decoded.email
            }, function (err, user) {
                if (err) throw err;

                if (!user) {
                    return res.status(403).send({success: false, msg: 'Authentication failed. User not found.'});
                } else {
                    logger.info('Get status from database.');
                    var number = req.headers.light;
                    var status = function (numberToCheck) {
                        if (!numberToCheck) {
                            Light.find({}, 'number state position status', function (err, light) {
                                var lightMap = {};

                                light.forEach(function (light) {
                                    lightMap[light._id] = light;
                                });

                                res.send(JSON.stringify(light));
                            });
                        } else {
                            Light.findOne({number: numberToCheck}, 'number state position status', function (err, light) {
                                res.send(JSON.stringify(light));
                            });
                        }
                        //return res.json({success: true, msg: 'POST request to lower the light'});
                    }
                    status(number);
                }
            });
        } else {
            return res.status(403).send({success: false, msg: 'No token provided.'});
        }

    });


    app.get('/status/door', function(req, res) {
        //get data from database
        var token = getToken(req.headers);
        if (token) {
            var decoded = jwt.decode(token, config.secret);
            User.findOne({
                email: decoded.email
            }, function (err, user) {
                if (err) throw err;

                if (!user) {
                    return res.status(403).send({success: false, msg: 'Authentication failed. User not found.'});
                } else {
                    logger.info('Get status from database.');
                    var number = req.headers.door;
                    var status = function(numberToCheck) {
                        if (!numberToCheck) {
                            Door.find({}, 'number state position status', function (err, door) {
                                var doorMap = {};

                                door.forEach(function (door) {
                                    doorMap[door._id] = door;
                                });

                                res.send(JSON.stringify(door));
                            });
                        } else {
                            Door.findOne({number: numberToCheck}, 'number state position status', function (err, door) {
                                res.send(JSON.stringify(door));
                            });
                        }
                    };
                    status(number);

                    //return res.json({success: true, msg: 'POST request to lower the light'});
                }
            });
        } else {
            return res.status(403).send({success: false, msg: 'No token provided.'});
        }

    });


    getToken = function (headers) {
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

};

