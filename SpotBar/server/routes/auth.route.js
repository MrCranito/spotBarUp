
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

    router.post('/testConnect', (req , resp, next)=>{
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
 
    var schemaUser = new mongoose.Schema({ username: 'string', name: 'string' , email: 'string', password:'string', friendList:'array', coordinateX:'number', coordinateY:'number',localisationActived:'Boolean'},{ collection : 'spotbarUser' });
    var modelUser = mongoose.model('User', schemaUser);
    const saltRounds = 10;

    router.post('/createUser', (req, resp, next )=>{

        //console.log(req);
        var username = req.body.username;
            name = req.body.name;
            email = req.body.email;
            password = req.body.password;
            json = {email : email};
            friendList = ["popopo@test.com"];
            coordinateX = 0;
            coordinateY = 0;
            localisationActived = true;

        modelUser.findOne(json, function(err, userChecking){
                if(err){ 
                       throw err;
                }
                else{
                    if(userChecking == null){
                        bcrypt.hash(password, saltRounds, function(err, hash) {
                            var json = {username: username, name: name, email: email, password: hash, friendList: friendList, coordinateX : coordinateX, coordinateY :coordinateY, localisationActived : localisationActived};
                            modelUser.create(json, function(err, json){
                                if(err){throw err;}
                                else{
                                    resp.json({
                                        status : "User Created !!"
                                    });
                                }
                            });
                        });
                    }
                    else{
                            if(err){
                                throw err;
                            }
                            else{
                                resp.json({
                                    user : userChecking,
                                    status : "User Exist"
                                });
                            }
                    }
                    
                }
        });
    });
    router.post('/checkUser', (req, resp, next )=>{

        //console.log(req);
        var email = req.body.email;
            reqpassword = req.body.password;
            json = {email : email};
        
        modelUser.findOne(json, function(err, userChecking){
            if(err){ 
                   throw err;
            }
            else{
                if(userChecking == null){
                    resp.json({
                        error : "User don't Exists"
                     });
                }
                else{
                    var hash = userChecking.password;
                    bcrypt.compare(reqpassword, hash, function(err, res) {
                        if(err){
                            throw err;
                        }
                        else{
                            resp.json({
                                user : userChecking,
                                status : "User Exist"
                            });
                        }
                      
                    });
                    
                }
                
            }
        });
    });

    router.get('/addFriend', (req, resp, next)=>{
        console.log(req);
        var email = req.body.email;
            friendToAdd = req.body.friend;
            json = {email : email};

        

        modelUser.findOne(json, function(err, userExists){
            if(err){
                throw err;
            }
            else{
                if(userExists == null){
                    resp.json({
                        error: "User don't Exists"
                    });
                }
                else{
                    var friendListUpdated =[];
                    userExists.friendList.forEach((row)=>{
                        friendListUpdated.push(row);
                    });
                    friendListUpdated.push(friendToAdd);
                    var json = {name : userExists.name,username : userExists.username, email : userExists.email, password : userExists.password,friendList : friendListUpdated, coordinateX : userExists.coordinateX, coordinateY : userExists.coordinateY, localisationActived: userExists.localisationActived };
                    modelUser.update(json, function(err, response){
                        if(err){
                            throw err;
                        }
                        else{
                            resp.json({
                                result : response
                            });
                        }
                    });
                }
            }
        });
    });
    router.get('/getUser', (req, resp, next )=>{

        var email = req.body.email;
            json = {email : email};

        modelUser.findOne(json, function(err, userChecking){
            if(err){ 
                   throw err;
            }
            else{
                if(userChecking == null){
                    resp.json({
                        error : "User don't Exists"
                     });
                }
                else{
                    resp.json({
                        username : userChecking.username,
                        name : userChecking.name,
                        email : userChecking.email,
                        password : userChecking.password,
                        coordinateX : userChecking.coordinateX,
                        coordinateY : userChecking.coordinateY,
                        localisationActived : userChecking.localisationActived
                    });
                }
                
            }
        });
    });
    router.post('/getUserFriend', (req, resp, next )=>{
        var email = req.body.email;
        var json = { email : email};
        modelUser.findOne(json, function(err, userChecking){
            if(err){ 
                   throw err;
            }
            else{
                if(userChecking == null){
                    resp.json({
                        error : "User don't Exists"
                     });
                }
                else{
                    resp.json({
                        username : userChecking.username,
                        name : userChecking.name,
                        email : userChecking.email,
                        password : userChecking.password,
                        friendList : userChecking.friendList
                    });
                }
                
            }
        }); 
    });

    return router;
    

}

module.exports.privateRoutes = function(){
    var router = express.Router();

    return router;

}
