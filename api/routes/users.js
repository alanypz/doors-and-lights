var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');
var users = require('../controllers/users');
var bcrypt = require('bcrypt');

var controller = {};


var secureStore = "";
var secureCompare = "";

/* GET users listing. */
router.get('/text', function(req, res) {
    res.send('<h2>Enter text</h2><form method="post" action="/text"><input name="txt"><button type="submit"></button>')
});

router.post('/text', function(req, res){
    bcrypt.genSalt(5,function(err, salt) {
       if (err) return next(err);
        bcrypt.hash(req.body.txt, salt, function(err, hash) {
            if (err) return next(err);
            secureStore = hash;
            res.redirect('/compare')
        });
    });
});

router.get('/compare', function(req, res) {
    res.send('<h2>Enter text to compare to hash <%=secureStore%></h2><form method="post" action="/compare"><input name="txt"><button type="submit"></button>')
});

router.post('/compare', function (req, res) {
    bcrypt.compare(req.body.txt, secureStore, function (err, match) {
        res.send(match);
    });
});

module.exports = router;
