
var express = require('express');
    MongoClient = require('mongodb').MongoClient,
    format = require('util').format;
    mongoose = require('mongoose');
    bcrypt = require('bcrypt');

   
module.exports.publicRoutes = function () {

    var schemaPro = new mongoose.Schema({email: 'string', password:'string', barName:'string', coordinateX : 'number', coordinateY:'number', description:'string',linkFb:'string', linkInsta: 'string', linkDigitik:'string', picture: 'string', hours:'array' },{ collection : 'spotbarPro' });
    
    var modelPro = mongoose.model('Pro', schemaPro);

    var router = express.Router();


    router.post('/getBar', (req, resp, next )=>{

        // console.log(req);
        var coordinateX = req.body.coordinateX;
            coordinateY = req.body.coordinateY;

        modelPro.find({}, function(err, barList){
                if(err){ 
                        throw err;
                }
                else{
                    resp.json({
                        result : barList
                    })
                }
        });
    });


    var modelClub = mongoose.model('Pro')
    router.post('/getNightClub', (req, resp, next )=>{

        // console.log(req);
        var coordinateX = req.body.coordinateX;
            coordinateY = req.body.coordinateY;

        modelClub.find({}, function(err, clubList){
                if(err){ 
                        throw err;
                }
                else{
                    resp.json({
                        result : clubList
                    })
                }
        });
    });
    var schemaBar = new mongoose.Schema({email: 'string', password:'string', barName:'string', coordinateX : 'number', coordinateY:'number', description:'string',linkFb:'string', linkInsta: 'string', linkDigitik:'string', picture: 'string', hours:'array' },
                                        { collection : 'spotbarPro' });

    var modelBar = mongoose.model('Bar', schemaBar);

    router.get('/createBar/:email/:password/:barname/:coordinateX/:coordinateY/:description/:linkFb/:linkInsta/:linkDigitik/:picture/:hours', (req, resp, next )=>{

        var email =req.params.email;
            password = req.params.password;
            barname = req.params.barname;
            coordinateX = req.params.coordinateX;
            coordinateY = req.params.coordinateY;
            description = req.params.description;
            linkFb = req.params.linkFb;
            linkInsta = req.params.Insta;
            linkDigitik = req.params.linkDigitik;
            picture = req.params.picture;
            hours = { monday : "Closed", tuesday : "Closed", Wednesday : [{open:"23:45", close:"06:00"}], Thursday : "23:45 - 06:00", Friday : "23:45 - 06:00", Sunday : "23:45 - 06:00", Saturday :"23:45 - 06:00"};

        bcrypt.hash(password, saltRounds, function(err, hash) {
            var json = {email : email, password : hash, barName : barname, coordinateX : coordinateX, coordinateY : coordinateY, description : description, linkFb : linkFb, linkInsta : linkInsta, linkDigitik : linkDigitik, picture : picture, hours : hours};

            modelBar.create(json, function(err, result){
                if(err){throw err;}
                else{
                    resp.json({
                        status : "Bar Created !!"+result
                    });
                }
            });
        });
        
    });
//    var schemaPro = new mongoose.Schema({ email: 'string', password:'string', barName:'string', coordinateX : 'number', coordinateY:'number', description:'string',linkFb:'string', linkInsta: 'string', linkDigitik:'string', picture: 'string'},
  //  { collection : 'spotbarNightClub' });

    //var modelPro = mongoose.model('NightClub', schemaPro);
    router.get('/createNightClub/:email/:password/:barname/:coordinateX/:coordinateY/:description/:linkFb/:linkInsta/:linkDigitik/:picture/:hours', (req, resp, next )=>{

        var email =req.params.email;
            password = req.params.password;
            barname = req.params.barname;
            coordinateX = req.params.coordinateX;
            coordinateY = req.params.coordinateY;
            description = req.params.description;
            linkFb = req.params.linkFb;
            linkInsta = req.params.Insta;
            linkDigitik = req.params.linkDigitik;
            picture = req.params.picture;
        // hours= req.params.hours;
        // hours = { monday : "Closed", tuesday : "Closed", Wednesday : [{open:"23:45", close:"06:00"}], Thursday : "23:45 - 06:00", Friday : "23:45 - 06:00", Sunday : "23:45 - 06:00", Saturday :"23:45 - 06:00"};
        
        bcrypt.hash(password, saltRounds, function(err, hash) {
            var json = {email : email, password : hash, barName : barname, coordinateX : coordinateX, coordinateY : coordinateY, description : description, linkFb : linkFb, linkInsta : linkInsta, linkDigitik : linkDigitik, picture : picture};

            modelPro.create(json, function(err, result){
                if(err){throw err;}
                else{
                    resp.json({
                        status : "Night CLub Created !!"+result
                    });
                }
            });
        });
        
    });

        return router;
}
module.exports.privateRoutes = function () {
    var router = express.Router();

    return router;
}