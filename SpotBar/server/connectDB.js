var mongoose = require('mongoose');

mongoose.connect('mongodb://localhost/spotbardb', function(err) {
  if (err) { throw err; }
  else{
      console.log("database Connected");
  }
});