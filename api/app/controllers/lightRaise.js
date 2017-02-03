//controllers/lightRaise.js
var http = require('http');
var Queue = require('../../utils/queue');
var raiseLightExecutionQueue = new Queue();
var raiseLightWaitingQueue = new Queue();
var lightDatabase = require('../models/light');

var logger = require("logger");

module.exports = {

    lightControl: function (lightQueue) {
        execute(lightQueue);
    }
};

function execute(lightNumber) {
    //create execution methods for the microcontroller
    lightDatabase.findOne({
        number: lightNumber
    }, function(err, light) {
        if (err) throw err;

        if (!light) {
            logger.info( 'Not able to find light.');
            console.log('info', 'Not able to find light.');
        } else {
            if (lightNumber%3 === 1){
                var ip = light.ip;
                //connect to the microcontroller and execute action
                //also listen to sensor information and completion of the job
                var options = {
                    host: ip,
                    path: '/arduino/raise1'
                };
                callback = function (response) {
                    var str = '';

                    //another chunk of data has been recieved, so append it to `str`
                    response.on('data', function (chunk) {
                        str += chunk;
                    });

                    //the whole response has been recieved, so we just print it out here
                    response.on('end', function () {
                        console.log(str);
                  });
                }

                http.request(options, callback).end();
                console.log("Bay ", ((lightNumber-1) / 3) +1, " light A being raised");
                logger.info("Bay ", ((lightNumber-1) / 3) +1, " light A being raised");

                lightDatabase.findOneAndUpdate(
                    {number: lightNumber},
                    {state: 'executing'},
                    function (err, light) {
                        if (err) throw err;

                    }
                );

            } else if (lightNumber%3 === 2){
                var ip = light.ip;
                //connect to the microcontroller and execute action
                //also listen to sensor information and completion of the job
                var options = {
                    host: ip,
                    path: '/arduino/raise2'
                };
                callback = function (response) {
                    var str = '';

                    //another chunk of data has been recieved, so append it to `str`
                    response.on('data', function (chunk) {
                        str += chunk;
                    });

                    //the whole response has been recieved, so we just print it out here
                    response.on('end', function () {
                        console.log(str);
                    });
                }

                http.request(options, callback).end();
                console.log("Bay ", ((lightNumber-1) / 3) +1, " light B being raised");
                logger.info("Bay ", ((lightNumber-1) / 3) +1, " light B being raised");

                lightDatabase.findOneAndUpdate(
                    {number: lightNumber},
                    {state: 'executing'},
                    function (err, light) {
                        if (err) throw err;

                    }
                );

            } else if (lightNumber%3 === 0){
                var ip = light.ip;
                //connect to the microcontroller and execute action
                //also listen to sensor information and completion of the job
                var options = {
                    host: ip,
                    path: '/arduino/raise3'
                };
                callback = function (response) {
                    var str = '';

                    //another chunk of data has been recieved, so append it to `str`
                    response.on('data', function (chunk) {
                        str += chunk;
                    });

                    //the whole response has been recieved, so we just print it out here
                    response.on('end', function () {
                        console.log(str);
                    });
                }

                http.request(options, callback).end();
                console.log("Bay ", ((lightNumber-1) / 3) +1, " light C being raised");
                logger.info("Bay ", ((lightNumber-1) / 3) +1, " light C being raised");

                lightDatabase.findOneAndUpdate(
                    {number: lightNumber},
                    {state: 'executing'},
                    function (err, light) {
                        if (err) throw err;

                    }
                );

            }
        }
    });

};

//function consumeLight(lightNumber) {
//
//
//    raiseLightExecutionQueue.enqueue(lightNumber);
//};
//
//
//function waitExecutionQueue(lightNumber) {
//    raiseLightWaitingQueue.enqueue(lightNumber);
//};
//
//function waitExecution5Min(lightNumber) {
//    setTimeout(function () {
//        lightStop(lightNumber);
//    }, 3000);
//};
//
//function lightStop(lightNumber) {
//    lightDatabase.findOneAndUpdate(
//        { number : lightNumber },
//        { state : 'stopped', position : 'raised' },
//        function(err, lightObject) {
//            if (err) throw err;
//        }
//    );
//
//    console.log("light ", lightNumber, " being stopped");
//    logger.info( 'light ' + lightNumber + ' being stopped');
//
//    //create execution methods for the microcontroller
//};

