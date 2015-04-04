
var express = require('express');
var restler = require('restler');
var unirest = require('unirest');

var app = express();

var array = ["+15109096676", "+15107097856"];

var Firebase = require('firebase'),
    usersRef = new Firebase('https://tasksms.firebaseio.com/users/');



 for (var i = 0; i < array.length; i++) {
// These code snippets use an open-source library.
unirest.post("https://twilio.p.mashape.com/AC1d8ae61e37d74d0e48947d095c9ae32d/SMS/Messages.json")
.header("Authorization", "Basic QUMxZDhhZTYxZTM3ZDc0ZDBlNDg5NDdkMDk1YzlhZTMyZDo0NDVmMmY5OGM4YTlkODJiNTUxMjNlM2VhMjRhOTgxNw==")
.header("X-Mashape-Key", "5uiZBYWupumshcTKlKIZwuTP5PQNp1CQSWKjsnPckXGf0dufZs")
.header("Content-Type", "application/x-www-form-urlencoded")
.header("Accept", "text/plain")
// .send("From", "+19258923685")
// .send("Body", "HELLO,,OKAY")
// .send("To", "+1 (510)-709-7856")

.send({ "From": "+19258923685", "Body": "topkek", "To": array[i]})
.end(function (result) {
  console.log(result.status, result.headers, result.body);
});
}


// app.all('/', function(request, response) {
//   restler.get('http://reddit.com/.json').on('complete', function(reddit) {
//     var titles = "<Response>";
//     for(var i=0; i<5; i++) {
//       titles += "<Sms>" + reddit.data.children[i].data.title + "</Sms>";
//     }
//     titles += "</Response>";
//     response.send(titles);
//   });
// });

// var port = process.env.PORT || 5000;
// app.listen(port, function() {
//   console.log("Listening on " + port);
// });
