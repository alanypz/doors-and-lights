//controllers/doorRaise.js
var Queue = require('../../utils/queue');
var raiseDoorExecutionQueue = new Queue();
var raiseDoorWaitingQueue = new Queue();
var doorDatabase = require('../models/door');
var config = require('../../config/database'); // get db config file

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
    doorDatabase.find({number : doorNumber}, function(err, doorObject) {
        if (err) throw err;

        // object of the door
        console.log(doorObject);
    });
};

function execute() {
    if(raiseDoorExecutionQueue.getLength()>0) {
        doorDatabase.findOneAndUpdate({ number : raiseDoorExecutionQueue.peek() }, { state : 'executing' }, function(err, doorObject) {
            if (err) throw err;

            // we have the updated user returned to us
            console.log(doorObject);
        });
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
    doorDatabase.findOneAndUpdate({ number : raiseDoorExecutionQueue.peek() }, { state : 'stopped' }, function(err, doorObject) {
        if (err) throw err;

        // we have the updated user returned to us
        console.log(doorObject);
    });
    console.log("door ", doorNumber, " being stopped");
    if (raiseDoorWaitingQueue.getLength() > 0) {
        raiseDoorExecutionQueue.enqueue(raiseDoorWaitingQueue.dequeue());
    }
    execute();
    //create execution methods for the microcontroller
};

