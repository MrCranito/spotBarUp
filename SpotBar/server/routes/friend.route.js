var express = require('express');
    MongoClient = require('mongodb').MongoClient,
    format = require('util').format;
    mongoose = require('mongoose');
    bcrypt = require('bcrypt');

   
module.exports.publicRoutes = function () {

    
    var router = express.Router();

    return router;



}

module.exports.privateRoutes = function () {
  
    var router = express.Router();

    return router;



}