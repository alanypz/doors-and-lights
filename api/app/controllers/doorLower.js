//controllers/doorLower.js
var Queue = require('../../utils/queue');
var lowerDoorExecutionQueue = new Queue();
var lowerDoorWaitingQueue = new Queue();
var doorDatabase = require('../models/door');

module.exports = {

    doorControl: function (doorQueue) {
        while(doorQueue.getLength() > 0) {
            if (lowerDoorExecutionQueue.getLength() < 5) {
                consumeDoor(doorQueue.dequeue());
            } else {
                waitExecutionQueue(doorQueue.dequeue());
            }
        }
        execute();
    }
};


function checkDatabase(doorNumber) {
    // connect to database and check its state
    doorDatabase.find({number : doorNumber}, function(err, doorObject) {
        if (err) throw err;

        // object of the door
        console.log(doorObject);
    });
};

function execute() {
    if(lowerDoorExecutionQueue.getLength()>0) {
        doorDatabase.findOneAndUpdate({ number : lowerDoorExecutionQueue.peek() }, { state : 'executing' }, function(err, doorObject) {
            if (err) throw err;

            // we have the updated user returned to us
            console.log(doorObject);
        });
        console.log("door ", lowerDoorExecutionQueue.peek(), " being lowered");
        waitExecution5Min();
    }
    //create execution methods for the microcontroller


};

function consumeDoor(doorNumber) {


    lowerDoorExecutionQueue.enqueue(doorNumber);
};


function waitExecutionQueue(doorNumber) {
    lowerDoorWaitingQueue.enqueue(doorNumber);
};

function waitExecution5Min() {
    setTimeout(function () {
        doorStop(lowerDoorExecutionQueue.dequeue());
    }, 3000);
};

function doorStop(doorNumber) {
    doorDatabase.findOneAndUpdate({ number : lowerDoorExecutionQueue.peek() }, { state : 'stopped' }, function(err, doorObject) {
        if (err) throw err;

        // we have the updated user returned to us
        console.log(doorObject);
    });
    console.log("door ", doorNumber, " being stopped");
    if (lowerDoorWaitingQueue.getLength() > 0) {
        lowerDoorExecutionQueue.enqueue(lowerDoorWaitingQueue.dequeue());
    }
    execute();
    //create execution methods for the microcontroller
};

