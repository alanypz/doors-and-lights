
// app/models/user.js
// load the things we need
var mongoose = require('mongoose');
var bcrypt   = require('bcrypt-nodejs');

// define the schema for our user model
var userSchema = mongoose.Schema({

    local            : {
        email        : String,
        password     : String,
    }
});

var LightSchema = new Schema({

  id                 : {
        type         : Number,
        required     : true,
        unique       : true
  },
  garage             : {
        type         : Number,
        required     : true,
        unique       : false
  },
  bay                : {
        type         : Number,
        required     : true,
        unique       : false
  },
  status             : {
        type         : Number,
        required     : true,
        unique       : false
  },
  lastUser           : {
        type         : String,
        required     : true,
        unique       : false
  },
  lastAction         : {
        type         : Date,
        required     : true,
        unique       : false },
});

var DoorSchema = new Schema({

  id                 : {
        type         : Number,
        required     : true,
        unique       : true
  },
  garage             : {
        type         : Number,
        required     : true,
        unique       : false
  },
  bay                : {
        type         : Number,
        required     : true,
        unique       : false
  },
  status             : {
        type         : Number,
        required     : true,
        unique       : false
  },
  lastUser           : {
        type         : String,
        required     : true,
        unique       : false
  },
  lastAction         : {
        type         : Date,
        required     : true,
        unique       : false
    }
});

// methods ======================
// generating a hash
userSchema.methods.generateHash = function(password) {
    return bcrypt.hashSync(password, bcrypt.genSaltSync(8), null);
};

// checking if password is valid
userSchema.methods.validPassword = function(password) {
    return bcrypt.compareSync(password, this.local.password);
};

// create the model for users and expose it to our app
module.exports = mongoose.model('User', userSchema);
