var express = require('express');
var app = express();
app.set('port', process.env.PORT || 3000);

var restler = require('restler');
var unirest = require('unirest');
var Firebase = require("firebase");

app.use(require('body-parser').json());
app.use(require('body-parser').urlencoded({extended: true}));

var twilio = require('twilio');
var client = new twilio.RestClient();

app.listen(app.get('port'), '0.0.0.0', function() {
  console.log('Server listening on port ' + app.get('port'));
});

var Firebase = require('firebase'),
    usersRef = new Firebase('https://tasksms.firebaseio.com/users/');

app.post('/sms', function(req, res) {
	var receivedText = req.body.Body;
    var number = req.body.From;

	if (number.substring(0, 1) == '+') { 
  		number = number.substring(1);
	}
    console.log(req.body);

	console.log('received ' + receivedText + ' from ' + number);

    var path = number + '/' + receivedText + '/actions';
    console.log(path);
    var actionsRef = usersRef.child(path);
    actionsRef.once('value', function(actions) {
    	for (var i = 0; i < actions.length; i++) {
    		var action = actions[i];
    		if (action.type === 'SMS') {
    			var message = action.message;
    			for (var j = 0; j < actions.recipients.length; j++) {
    				var recipient = actions.recipients[j];
    				recipient = '+' + recipient;
    				sendSMS(recipient, message);
    			}
    		}
    	}
    });
});

var sendSMS = function(number, message) {
	console.log('sending ' + message + ' to ' + number);
	unirest.post("https://twilio.p.mashape.com/AC1d8ae61e37d74d0e48947d095c9ae32d/SMS/Messages.json")
		.header("Authorization", "Basic QUMxZDhhZTYxZTM3ZDc0ZDBlNDg5NDdkMDk1YzlhZTMyZDo0NDVmMmY5OGM4YTlkODJiNTUxMjNlM2VhMjRhOTgxNw==")
		.header("X-Mashape-Key", "5uiZBYWupumshcTKlKIZwuTP5PQNp1CQSWKjsnPckXGf0dufZs")
		.header("Content-Type", "application/x-www-form-urlencoded")
		.header("Accept", "text/plain")
		.send({ "From": "+19258923685", "Body": message, "To": number})
		.end(function (result) {
	  		console.log(result.status, result.headers, result.body);
		});
};


// if (array) {

// for (var i = 0; i < array.length; i++) {
// // These code snippets use an open-source library.
// unirest.post("https://twilio.p.mashape.com/AC1d8ae61e37d74d0e48947d095c9ae32d/SMS/Messages.json")
// .header("Authorization", "Basic QUMxZDhhZTYxZTM3ZDc0ZDBlNDg5NDdkMDk1YzlhZTMyZDo0NDVmMmY5OGM4YTlkODJiNTUxMjNlM2VhMjRhOTgxNw==")
// .header("X-Mashape-Key", "5uiZBYWupumshcTKlKIZwuTP5PQNp1CQSWKjsnPckXGf0dufZs")
// .header("Content-Type", "application/x-www-form-urlencoded")
// .header("Accept", "text/plain")
// // .send("From", "+19258923685")
// // .send("Body", "HELLO,,OKAY")
// // .send("To", "+1 (510)-709-7856")
// .send({ "From": "+19258923685", "Body": "topkek", "To": array[i]})
// .end(function (result) {
//   console.log(result.status, result.headers, result.body);
// });
// }
// }

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
