var express = require('express');
    MongoClient = require('mongodb').MongoClient,
    format = require('util').format;
    mongoose = require('mongoose');
    bcrypt = require('bcrypt');




module.exports.publicRoutes = function () {

        mongoose.connect('mongodb://localhost/spotbardb', function(err) {
            if (err) { throw err; }
            else{
                console.log("database Connected");
            }
        });
        var router = express.Router();
        
        router.post('/connectDB', (req , resp, next)=>{
            var country = req.body.country;
            state = req.body.state;
            concat = country+"."+state+".Bar";

       //console.log(req);
        mongoose.connection.db.collection(concat, function(err, collection){
            if(err){
                    resp.json({
                        errorOnConnect : "Error During Connection DB"+ err
                    });
            }
            else{
                collection.findOne({}, function(err, result){
                        if(err){
                            console.log("No Data Provided")
                        }
                        else{
                            if(result == null){
                                var createNewSchema = new mongoose.Schema({ email: 'string', password:'string', barName:'string', coordinateX : 'number', coordinateY:'number', description:'string',linkFb:'string', linkInsta: 'string', linkDigitik:'string', picture: 'string'},
                                { collection : concat });
                                var json = { email: 'ok', password:'ok', barName:'ok', coordinateX : '1', coordinateY:'2', description:'ok',linkFb:'ok', linkInsta: 'ok', linkDigitik:'ok', picture: 'ok'};
                                var modelnewSchema = mongoose.model('spotbar'+concat, createNewSchema);
                                modelnewSchema.create(json, function(err, result){
                                        if(err){
                                            resp.json({
                                                result : "Schema Creation Failed"
                                            });
                                        }
                                        else{
                                            resp.json({
                                                result : "Schema Creation Success"
                                            });
                                        }
                                });
                            }
                            else{
                                resp.json({
                                    result :"DB already exists"
                                })
                            }
                            
                        }
                });
            }
        });
});
    
    var router = express.Router();

    return router;
}
module.exports.privateRoutes = function () {

    var router = express.Router();

    return router;

}