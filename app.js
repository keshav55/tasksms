
var express = require('express');
var restler = require('restler');
var unirest = require('unirest');
var Firebase = require("firebase");
var twilio = require('twilio');
var client = require('twilio')('AC1d8ae61e37d74d0e48947d095c9ae32d','445f2f98c8a9d82b55123e3ea24a9817')

var app = express();


var myFirebaseRef = new Firebase("https://tasksms.firebaseio.com/");












var Firebase = require('firebase'),
    usersRef = new Firebase('https://tasksms.firebaseio.com/users/');





var array = ["+15107097856"];

app.post('/sms', function(req, res) {
    if (twilio.validateExpressRequest(req, process.env.TWILIO_AUTH_TOKEN)) {
        var receivedText = req.body.Body;
        var number = req.body.from;

        var path = number + '/' + receivedText;
        var workflowRef = usersRef.child(path);
        workflowRef.once("actions", function(actions) {
        	for (var action in actions) {
        		if (action.type === 'SMS') {

        		}
        	}
        });
    } else {
        res.send('you are not twilio.  Buzz off.');
    }
});

// var sendSMS(num message) {
// 	unirest.post("https://twilio.p.mashape.com/AC1d8ae61e37d74d0e48947d095c9ae32d/SMS/Messages.json")
// 		.header("Authorization", "Basic QUMxZDhhZTYxZTM3ZDc0ZDBlNDg5NDdkMDk1YzlhZTMyZDo0NDVmMmY5OGM4YTlkODJiNTUxMjNlM2VhMjRhOTgxNw==")
// 		.header("X-Mashape-Key", "5uiZBYWupumshcTKlKIZwuTP5PQNp1CQSWKjsnPckXGf0dufZs")
// 		.header("Content-Type", "application/x-www-form-urlencoded")
// 		.header("Accept", "text/plain")
// 		.send({ "From": "+19258923685", "Body": message, "To": number})
// 		.end(function (result) {
// 	  		console.log(result.status, result.headers, result.body);
// 		});
// 	}
// };


if (array) {

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
