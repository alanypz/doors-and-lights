//controllers/lightLower.js
var Queue = require('../../utils/queue');
var lowerLightExecutionQueue = new Queue();
var lowerLightWaitingQueue = new Queue();
var lightDatabase = require('../models/light');

module.exports = {

    lightControl: function (lightQueue) {
        while(lightQueue.getLength() > 0) {
            if (lowerLightExecutionQueue.getLength() < 5) {
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
    if(lowerLightExecutionQueue.getLength()>0) {
        lightDatabase.findOneAndUpdate({ number : lowerLightExecutionQueue.peek() }, { state : 'executing' }, function(err, lightObject) {
            if (err) throw err;

            // we have the updated user returned to us
            console.log(lightObject);
        });
        console.log("light ", lowerLightExecutionQueue.peek(), " being lowered");
        waitExecution5Min();
    }
    //create execution methods for the microcontroller


};

function consumeLight(lightNumber) {


    lowerLightExecutionQueue.enqueue(lightNumber);
};


function waitExecutionQueue(lightNumber) {
    lowerLightWaitingQueue.enqueue(lightNumber);
};

function waitExecution5Min() {
    setTimeout(function () {
        lightStop(lowerLightExecutionQueue.dequeue());
    }, 3000);
};

function lightStop(lightNumber) {
    lightDatabase.findOneAndUpdate({ number : lowerLightExecutionQueue.peek() }, { state : 'stopped' }, function(err, lightObject) {
        if (err) throw err;

        // we have the updated user returned to us
        console.log(lightObject);
    });
    console.log("light ", lightNumber, " being stopped");
    if (lowerLightWaitingQueue.getLength() > 0) {
        lowerLightExecutionQueue.enqueue(lowerLightWaitingQueue.dequeue());
    }
    execute();
    //create execution methods for the microcontroller
};

