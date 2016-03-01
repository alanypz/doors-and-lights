//controllers/doorRaise.js
var Queue = require('../../utils/queue');
var raiseDoorExecutionQueue = new Queue();
var raiseDoorWaitingQueue = new Queue();
var doorDatabase = require('../models/door');
var config = require('../../config/database'); // get db config file

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
            logger.log('info', 'Not able to find door.');
            console.log('info', 'Not able to find door.');
        } else {
            var ip = door.ip;
            //connect to the microcontroller and execute action
            //also listen to sensor information and completion of the job
            console.log("door ", doorNumber, " being raised");
            logger.log("door ", doorNumber, " being raised");

            doorDatabase.findOneAndUpdate(
                {number : doorNumber },
                { state : 'executing' },
                function(err, door) {
                    if (err) throw err;

                }
            );

            waitExecution5Min(doorNumber);
        }
    });

};

function consumeDoor(doorNumber) {


    raiseDoorExecutionQueue.enqueue(doorNumber);
};


function waitExecutionQueue(doorNumber) {
    raiseDoorWaitingQueue.enqueue(doorNumber);
};

function waitExecution5Min(doorNumber) {
    setTimeout(function () {
        doorStop(doorNumber);
    }, 3000);
};

function doorStop(doorNumber) {
    doorDatabase.findOneAndUpdate(
        { number : doorNumber },
        { state : 'stopped', position : 'raised' },
        function(err, doorObject) {
            if (err) throw err;
        }
    );

    console.log("door ", doorNumber, " being stopped");
    logger.log('info', 'door ' + doorNumber + ' being stopped');

    //create execution methods for the microcontroller
};


