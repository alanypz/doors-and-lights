
var mongoose = require('mongoose');

var lightSchema = mongoose.Schema({

    light                  : {
        number            : Number,
        state             : String,
        position          : String,
        ip                : String,
        lastAtcionTime    : { type: Date, default: Date.now },
    }

});


module.exports = mongoose.model('Light', lightSchema);