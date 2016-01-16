//var mongoose = require('mongoose'),
//    Door = mongoose.model('door'),
//    controller = {};
//
//doorController.raise = [
//    function(req,res,next){
//        res.render('door/index', {door:[]});
//    }
//];
//
//doorController.lower = [
//    function(req, res,next){
//        if("number" in req.body && req.body.number != ''){
//            next();
//        } else {
//            res.send(400);
//        }
//
//    },
//    function(req, res, next){
//        Door.create(req.body, function(err, door) {
//            if(err) return next(err);
//            res.json(door);
//        });
//    }
//];
//
//doorController.eStop = [
//    function(req,res,next){
//        res.render('door/index', {door:[]});
//    }
//];
//
//
//doorController.update =  [
//    function(req, res,next){
//        next();
//    },
//    function(req, res, next){
//
//    }
//];
//
//module.export = controller;