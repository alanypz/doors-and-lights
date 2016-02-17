//// app/models/user.js
//// load the things we need
//var mongoose = require('mongoose');
//var bcrypt   = require('bcrypt-nodejs');
//
//// define the schema for our user model
//var userSchema = mongoose.Schema({
//
//    local            : {
//        email        : String,
//        password     : String,
//    },
//    facebook         : {
//        id           : String,
//        token        : String,
//        email        : String,
//        name         : String
//    },
//    twitter          : {
//        id           : String,
//        token        : String,
//        displayName  : String,
//        username     : String
//    },
//    google           : {
//        id           : String,
//        token        : String,
//        email        : String,
//        name         : String
//    }
//
//});
//
//// methods ======================
//// generating a hash
//userSchema.methods.generateHash = function(password) {
//    return bcrypt.hashSync(password, bcrypt.genSaltSync(8), null);
//};
//
//// checking if password is valid
//userSchema.methods.validPassword = function(password) {
//    return bcrypt.compareSync(password, this.local.password);
//};
//
//// create the model for users and expose it to our app
//module.exports = mongoose.model('User', userSchema);
var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var bcrypt = require('bcrypt');

// set up a mongoose model
var UserSchema = new Schema({
    email: {
        type: String,
        unique: true,
        required: true
    },
    password: {
        type: String,
        required: true
    }
});

UserSchema.pre('save', function (next) {
    var user = this;
    if (this.isModified('password') || this.isNew) {
        bcrypt.genSalt(10, function (err, salt) {
            if (err) {
                return next(err);
            }
            bcrypt.hash(user.password, salt, function (err, hash) {
                if (err) {
                    return next(err);
                }
                user.password = hash;
                next();
            });
        });
    } else {
        return next();
    }
});

UserSchema.methods.comparePassword = function (passw, cb) {
    bcrypt.compare(passw, this.password, function (err, isMatch) {
        if (err) {
            return cb(err);
        }
        cb(null, isMatch);
    });
};

module.exports = mongoose.model('User', UserSchema);