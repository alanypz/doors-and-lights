//controllers/doorUpdate.js
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
        doorUpdate(ip.split("f:").pop(), status);
    }
};


function doorUpdate(ip, status) {
    if (status === 'raised'){
        doorDatabase.findOneAndUpdate(
            {ip: ip},
            {state : 'stopped', position : 'raised'},
            function (err, doorObject) {
                if (err) throw err;

            }
        );
    } else if(status === 'lowered'){
        doorDatabase.findOneAndUpdate(
            {ip: ip},
            {state : 'stopped', position : 'lowered'},
            function (err, doorObject) {
                if (err) throw err;

            }
        );
    } else if( status === 'error') {
        doorDatabase.findOneAndUpdate(
            {ip: ip},
            {state : 'stopped', position : 'error'},
            function (err, doorObject) {
                if (err) throw err;

            }
        );
    } else if (status === 'executing'){
        doorDatabase.findOneAndUpdate(
            {ip: ip},
            {state: 'executing'},
            function (err, doorObject) {
                if (err) throw err;

            }
        );
    }

};
