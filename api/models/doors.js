var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var DoorSchema = new Schema({
    number:Number,
    location:String,
    ip:String,
    updated: { type: Date, default: Date.now }
});

mongoose.model('door',DoorSchema);