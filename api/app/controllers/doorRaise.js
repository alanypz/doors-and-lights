//controllers/doorRaise.js
var http = require('http');
var Queue = require('../../utils/queue');
var raiseDoorExecutionQueue = new Queue();
var raiseDoorWaitingQueue = new Queue();
var doorDatabase = require('../models/door');
var config = require('../../config/database'); // get db config file

var logger = require("logger");

module.exports = {

    doorControl: function (doorQueue) {
        execute(doorQueue);
    }
};

function execute(doorNumber) {
    //create execution methods for the microcontroller
    doorDatabase.findOne({
        number: doorNumber
    }, function(err, door) {
        if (err) throw err;

        if (!door) {
            logger.info( 'Not able to find door.');
            console.log('info', 'Not able to find door.');
        } else {
            var ip = door.ip;
            //connect to the microcontroller and execute action
            //also listen to sensor information and completion of the job
            var options = {
                host: ip,
                path: '/arduino/raise'
            };
            callback = function(response) {
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
            console.log("door ", doorNumber, " being raised");
            logger.info("door ", doorNumber, " being raised");

            doorDatabase.findOneAndUpdate(
                {number : doorNumber },
                { state : 'executing' },
                function(err, door) {
                    if (err) throw err;

                }
            );


        }
    });

};
//
//function consumeDoor(doorNumber) {
//
//
//    raiseDoorExecutionQueue.enqueue(doorNumber);
//};
//
//
//function waitExecutionQueue(doorNumber) {
//    raiseDoorWaitingQueue.enqueue(doorNumber);
//};
//
//function waitExecution5Min(doorNumber) {
//    setTimeout(function () {
//        doorStop(doorNumber);
//    }, 3000);
//};

//function doorStop(doorNumber) {
//    doorDatabase.findOneAndUpdate(
//        { number : doorNumber },
//        { state : 'stopped', position : 'middle' },
//        function(err, doorObject) {
//            if (err) throw err;
//
//            if (!door) {
//                logger.info('Not able to find door.');
//                console.log('info', 'Not able to find door.');
//            } else {
//                var ip = door.ip;
//                //connect to the microcontroller and execute action
//                //also listen to sensor information and completion of the job
//                var options = {
//                    host: ip,
//                    path: '/arduino/stop'
//                };
//                callback = function (response) {
//                    var str = '';
//
//                    //another chunk of data has been recieved, so append it to `str`
//                    response.on('data', function (chunk) {
//                        str += chunk;
//                    });
//
//                    //the whole response has been recieved, so we just print it out here
//                    response.on('end', function () {
//                        console.log(str);
//                    });
//                }
//
//                http.request(options, callback).end();
//                console.log("door ", doorNumber, " being stopped");
//                logger.info("door ", doorNumber, " being stopped");
//
//
//
//
//            }
//        }
//    );
//
//
//    //create execution methods for the microcontroller
//};
//
//
