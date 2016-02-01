//controllers/doorRaise.js
var Queue = require('../../utils/queue');
var raiseDoorExecutionQueue = new Queue();
var raiseDoorWaitingQueue = new Queue();
//var mongoose = require('mongoose');
//var configDBDoor = require('../../config/databaseDoors.js');
//mongoose.connect(configDBDoor.url); // connect to our door database

module.exports = {

    doorControl: function (doorQueue) {
        while(doorQueue.getLength() > 0) {
            if (raiseDoorExecutionQueue.getLength() < 5) {
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
};

function execute() {
    if(raiseDoorExecutionQueue.getLength()>0) {
        console.log("door ", raiseDoorExecutionQueue.peek(), " being raised");
        waitExecution5Min();
    }
    //create execution methods for the microcontroller


};

function consumeDoor(doorNumber) {
    raiseDoorExecutionQueue.enqueue(doorNumber);
};


function waitExecutionQueue(doorNumber) {
    raiseDoorWaitingQueue.enqueue(doorNumber);
};

function waitExecution5Min() {
    setTimeout(function () {
        doorStop(raiseDoorExecutionQueue.dequeue());
    }, 3000);
};

function doorStop(doorNumber) {
    console.log("door ", doorNumber, " being stopped");
    if (raiseDoorWaitingQueue.getLength() > 0) {
        raiseDoorExecutionQueue.enqueue(raiseDoorWaitingQueue.dequeue());
    }
    execute();
    //create execution methods for the microcontroller
};

