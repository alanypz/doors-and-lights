//controllers/doorLower.js
var Queue = require('../../utils/queue');
var lowerDoorExecutionQueue = new Queue();
var lowerDoorWaitingQueue = new Queue();
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
        execute(doorQueue);
    }
};


//function checkDatabase(doorNumber) {
//    // connect to database and check its state
//    doorDatabase.find({number : doorNumber}, function(err, doorObject) {
//        if (err) throw err;
//
//        // object of the door
//        console.log(doorObject);
//    });
//};

function execute(doorNumber) {
    //if(lowerDoorExecutionQueue.getLength()>0) {
    //    doorDatabase.findOneAndUpdate({ number : lowerDoorExecutionQueue.peek() }, { state : 'executing' }, function(err, doorObject) {
    //        if (err) throw err;
    //
    //        // we have the updated user returned to us
    //        console.log(doorObject);
    //    });
    //    console.log("door ", lowerDoorExecutionQueue.peek(), " being lowered");
    //    waitExecution5Min();
    //}
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
            console.log("door ", doorNumber, " being lowered");
            logger.log("door ", doorNumber, " being lowered");

            doorDatabase.findOneAndUpdate(
                {number : doorNumber },
                { state : 'executing' },
                function(err, door) {
                        if (err) throw err;

                        // we have the updated user returned to us
                        //console.log(door);
                        //logger.log('info', door);
                }
            );

            waitExecution5Min(doorNumber);
        }
    });

};

function consumeDoor(doorNumber) {


    lowerDoorExecutionQueue.enqueue(doorNumber);
};


function waitExecutionQueue(doorNumber) {
    lowerDoorWaitingQueue.enqueue(doorNumber);
};

function waitExecution5Min(doorNumber) {
    setTimeout(function () {
        doorStop(doorNumber);
    }, 3000);
};

function doorStop(doorNumber) {
    doorDatabase.findOneAndUpdate(
        { number : doorNumber },
        { state : 'stopped', position : 'lower' },
        function(err, doorObject) {
            if (err) throw err;

            // we have the updated user returned to us
            //console.log(doorObject);
            //logger.log('info', doorObject);
        }
    );

    console.log("door ", doorNumber, " being stopped");
    logger.log('info', 'door ' + doorNumber + ' being stopped');
    //if (lowerDoorWaitingQueue.getLength() > 0) {
    //    lowerDoorExecutionQueue.enqueue(lowerDoorWaitingQueue.dequeue());
    //}
    //execute();
    //create execution methods for the microcontroller
};

