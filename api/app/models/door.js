
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var DoorSchema = new Schema({

        number            : {
            type          :Number,
            unique        :true,
            required      :true
        },
        state             : {
            type          :String,
            unique        :true,
            required      :true
        },
        position          : {
            type          :String,
            unique        :true,
            required      :true
        },
        ip                : {
            type          :String,
            unique        :true,
            required      :true
        },
        lastAtcionTime    : {
            type: Date,
            default: Date.now
        }

});

module.exports = mongoose.model('Door', DoorSchema);

