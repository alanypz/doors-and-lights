//controllers/doorStop.js
var http = require('http');
var Queue = require('../../utils/queue');
var doorDatabase = require('../models/door');

var logger = require("logger");
module.exports = {

    doorControl: function (doorQueue) {
        //while(doorQueue.getLength() > 0) {
        //    if (lowerDoorExecutionQueue.getLength() < 5) {
        //        consumeDoor(doorQueue.dequeue());
        //    } else {
        //        waitExecutionQueue(doorQueue.dequeue());
        //    }
        //}
        doorStop(doorQueue);
    }
};

function doorStop(doorNumber) {
    doorDatabase.findOneAndUpdate(
        { number : doorNumber },
        { state : 'stopped', position : 'lowered' },
        function(err, doorObject) {
            if (err) throw err;

            if (!door) {
                logger.info('Not able to find door.');
                console.log('info', 'Not able to find door.');
            } else {
                var ip = door.ip;
                //connect to the microcontroller and execute action
                //also listen to sensor information and completion of the job
                var options = {
                    host: ip,
                    path: '/arduino/stop'
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
                console.log("door ", doorNumber, " being stopped");
                logger.info("door ", doorNumber, " being stopped");




            }
        }
    );

};

