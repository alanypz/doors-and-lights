
var mongoose = require('mongoose');

var doorSchema = mongoose.Schema({

    door                  : {
        number            : Number,
        state             : String,
        ip                : String,
        lastAtcionTime    : { type: Date, default: Date.now },
    }

});

module.exports = mongoose.model('Door', doorSchema);