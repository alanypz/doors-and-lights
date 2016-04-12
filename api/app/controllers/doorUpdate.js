//controllers/doorStop.js
var http = require('http');
var Queue = require('../../utils/queue');
var doorDatabase = require('../models/door');

var logger = require("logger");
module.exports = {

    doorControl: function (ip, status) {
        //while(doorQueue.getLength() > 0) {
        //    if (lowerDoorExecutionQueue.getLength() < 5) {
        //        consumeDoor(doorQueue.dequeue());
        //    } else {
        //        waitExecutionQueue(doorQueue.dequeue());
        //    }
        //}
        doorUpdate(ip, status);
    }
};


function doorUpdate(ip, status) {
    doorDatabase.findOneAndUpdate(
        { ip : ip },
        { state : status },
        function(err, doorObject) {
            if (err) throw err;

        }
    );

};
