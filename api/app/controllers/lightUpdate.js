//controllers/doorUpdate.js
var http = require('http');
var Queue = require('../../utils/queue');
var lightDatabase = require('../models/light');

var logger = require("logger");
module.exports = {

    lightControl: function (ip, status) {
        //while(doorQueue.getLength() > 0) {
        //    if (lowerDoorExecutionQueue.getLength() < 5) {
        //        consumeDoor(doorQueue.dequeue());
        //    } else {
        //        waitExecutionQueue(doorQueue.dequeue());
        //    }
        //}
        lightUpdate(ip.split("f:").pop(), status);
    }
};


function lightUpdate(ip, status) {
    if (status === 'raised1'){

        lightDatabase.findOneAndUpdate(
            {number : 1},
            {state : 'stopped', position : 'raised'},
            function (err, doorObject) {
                if (err) throw err;

            }
        );
    } else if(status === 'lowered1'){
        lightDatabase.findOneAndUpdate(
            {number : 1},
            {state : 'stopped', position : 'lowered'},
            function (err, doorObject) {
                if (err) throw err;

            }
        );
    } else if( status === 'error1') {
        lightDatabase.findOneAndUpdate(
            {number : 1},
            {state : 'stopped', position : 'error'},
            function (err, doorObject) {
                if (err) throw err;

            }
        );
    } else if (status === 'executing1'){
        lightDatabase.findOneAndUpdate(
            {number : 1},
            {state: 'executing'},
            function (err, doorObject) {
                if (err) throw err;

            }
        );
    }else if (status === 'raised2'){
        lightDatabase.findOneAndUpdate(
            {number : 2},
            {state : 'stopped', position : 'raised'},
            function (err, doorObject) {
                if (err) throw err;

            }
        );
    } else if(status === 'lowered2'){
        lightDatabase.findOneAndUpdate(
            {number : 2},
            {state : 'stopped', position : 'lowered'},
            function (err, doorObject) {
                if (err) throw err;

            }
        );
    } else if( status === 'error2') {
        lightDatabase.findOneAndUpdate(
            {number : 2},
            {state : 'stopped', position : 'error'},
            function (err, doorObject) {
                if (err) throw err;

            }
        );
    } else if (status === 'executing2'){
        lightDatabase.findOneAndUpdate(
            {number : 2},
            {state: 'executing'},
            function (err, doorObject) {
                if (err) throw err;

            }
        );
    }else if (status === 'raised3'){
        lightDatabase.findOneAndUpdate(
            {number : 3},
            {state : 'stopped', position : 'raised'},
            function (err, doorObject) {
                if (err) throw err;

            }
        );
    } else if(status === 'lowered3'){
        lightDatabase.findOneAndUpdate(
            {number : 3},
            {state : 'stopped', position : 'lowered'},
            function (err, doorObject) {
                if (err) throw err;

            }
        );
    } else if( status === 'error3') {
        lightDatabase.findOneAndUpdate(
            {number : 3},
            {state : 'stopped', position : 'error'},
            function (err, doorObject) {
                if (err) throw err;

            }
        );
    } else if (status === 'executing3'){
        lightDatabase.findOneAndUpdate(
            {number : 3},
            {state: 'executing'},
            function (err, doorObject) {
                if (err) throw err;

            }
        );
    }

};
