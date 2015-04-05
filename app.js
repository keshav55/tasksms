var express = require('express');
var app = express();
app.set('port', process.env.PORT || 3000);

var restler = require('restler');
var unirest = require('unirest');
var Firebase = require("firebase");
var twilio = require('twilio');
var client = require('twilio')('AC1d8ae61e37d74d0e48947d095c9ae32d','')

var app = express();


var myFirebaseRef = new Firebase("https://tasksms.firebaseio.com/");







app.use(require('body-parser').json());
app.use(require('body-parser').urlencoded({extended: true}));

var twilio = require('twilio');
var client = new twilio.RestClient();

app.listen(app.get('port'), '0.0.0.0', function() {
  console.log('Server listening on port ' + app.get('port'));
});

var Firebase = require('firebase'),
    myFirebaseRef = new Firebase('https://tasksms.firebaseio.com/');

app.post('/sms', function(req, res) {
	var receivedText = req.body.Body;
    var number = req.body.From;

	if (number.substring(0, 1) == '+') { 
  		number = number.substring(1);
	}
    console.log(req.body);

	console.log('received ' + receivedText + ' from ' + number);

    var path = 'users' + '/' + number + '/' + receivedText + '/actions';
    console.log(path);
    var actionsRef = myFirebaseRef.child(path);
    console.log(actionsRef);
    actionsRef.once('value', function(actionsSnapshot) {
    	var actions = actionsSnapshot.val();
    	console.log(actions);
    	for (var i = 0; i < actions.length; i++) {
    		var action = actions[i];
    		console.log(action);
    		if (action.type === 'SMS') {
    			var message = action.message;
    			console.log(action.recipients);
    			for (var j = 0; j < actions.recipients.length; j++) {
    				var recipient = actions.recipients[j];
    				console.log(recipient);
    				recipient = '+' + recipient;
    				sendSMS(recipient, message);
    			}
    		}
    	}
    });
});



if (array) {

for (var i = 0; i < array.length; i++) {
// These code snippets use an open-source library.
unirest.post("https://twilio.p.mashape.com/AC1d8ae61e37d74d0e48947d095c9ae32d/SMS/Messages.json")
.header("Authorization", "Basic QUMxZDhhZTYxZTM3ZDc0ZDBlNDg5NDdkMDk1YzlhZTMyZDo0NDVmMmY5OGM4YTlkODJiNTUxMjNlM2VhMjRhOTgxNw==")
.header("X-Mashape-Key", "5uiZBYWupumshcTKlKIZwuTP5PQNp1CQSWKjsnPckXGf0dufZs")
.header("Content-Type", "application/x-www-form-urlencoded")
.header("Accept", "text/plain")
.send({ "From": "+19258923685", "Body": "topkek", "To": array[i]})
.end(function (result) {
  console.log(result.status, result.headers, result.body);
});
}
}

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



