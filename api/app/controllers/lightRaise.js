//controllers/lightRaise.js
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
            logger.log('info', 'Not able to find light.');
            console.log('info', 'Not able to find light.');
        } else {
            var ip = light.ip;
            //connect to the microcontroller and execute action
            //also listen to sensor information and completion of the job
            console.log("light ", lightNumber, " being raised");
            logger.log("light ", lightNumber, " being raised");

            lightDatabase.findOneAndUpdate(
                {number : lightNumber },
                { state : 'executing' },
                function(err, light) {
                    if (err) throw err;

                }
            );

            waitExecution5Min(lightNumber);
        }
    });

};

function consumeLight(lightNumber) {


    raiseLightExecutionQueue.enqueue(lightNumber);
};


function waitExecutionQueue(lightNumber) {
    raiseLightWaitingQueue.enqueue(lightNumber);
};

function waitExecution5Min(lightNumber) {
    setTimeout(function () {
        lightStop(lightNumber);
    }, 3000);
};

function lightStop(lightNumber) {
    lightDatabase.findOneAndUpdate(
        { number : lightNumber },
        { state : 'stopped', position : 'raised' },
        function(err, lightObject) {
            if (err) throw err;
        }
    );

    console.log("light ", lightNumber, " being stopped");
    logger.log('info', 'light ' + lightNumber + ' being stopped');

    //create execution methods for the microcontroller
};