//controllers/lightRaise.js
var Queue = require('../../utils/queue');
var raiseLightExecutionQueue = new Queue();
var raiseLightWaitingQueue = new Queue();
var lightDatabase = require('../models/light');

module.exports = {

    lightControl: function (lightQueue) {
        while(lightQueue.getLength() > 0) {
            if (raiseLightExecutionQueue.getLength() < 5) {
                consumeLight(lightQueue.dequeue());
            } else {
                waitExecutionQueue(lightQueue.dequeue());
            }
        }
        execute();
    }
};


function checkDatabase(lightNumber) {
    // connect to database and check its state
    lightDatabase.find({number : lightNumber}, function(err, lightObject) {
        if (err) throw err;

        // object of the light
        console.log(lightObject);
    });
};

function execute() {
    if(raiseLightExecutionQueue.getLength()>0) {
        lightDatabase.findOneAndUpdate({ number : raiseLightExecutionQueue.peek() }, { state : 'executing' }, function(err, lightObject) {
            if (err) throw err;

            // we have the updated user returned to us
            console.log(lightObject);
        });
        console.log("light ", raiseLightExecutionQueue.peek(), " being raised");
        waitExecution5Min();
    }
    //create execution methods for the microcontroller


};

function consumeLight(lightNumber) {


    raiseLightExecutionQueue.enqueue(lightNumber);
};


function waitExecutionQueue(lightNumber) {
    raiseLightWaitingQueue.enqueue(lightNumber);
};

function waitExecution5Min() {
    setTimeout(function () {
        lightStop(raiseLightExecutionQueue.dequeue());
    }, 3000);
};

function lightStop(lightNumber) {
    lightDatabase.findOneAndUpdate({ number : raiseLightExecutionQueue.peek() }, { state : 'stopped' }, function(err, lightObject) {
        if (err) throw err;

        // we have the updated user returned to us
        console.log(lightObject);
    });
    console.log("light ", lightNumber, " being stopped");
    if (raiseLightWaitingQueue.getLength() > 0) {
        raiseLightExecutionQueue.enqueue(raiseLightWaitingQueue.dequeue());
    }
    execute();
    //create execution methods for the microcontroller
};

