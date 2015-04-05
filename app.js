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

app.configure(function () {
    /* Configure your express app... */
    app.use(express.urlencoded());
});


var Firebase = require('firebase'),
    usersRef = new Firebase('https://tasksms.firebaseio.com/users/');

app.post('/sms', function(req, res) {
	console.log(process.env.TWILIO_AUTH_TOKEN);
    if (twilio.validateExpressRequest(req, process.env.TWILIO_AUTH_TOKEN)) {
        var receivedText = req.body.Body;
        var number = req.body.from;

    	console.log('recieved from ' + number);

        var path = number + '/' + receivedText;
        console.log(path);
        var workflowRef = usersRef.child(path);
        workflowRef.once('actions', function(actions) {
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
    } else {
    	console.log('could not validate request');
        res.send('you are not twilio.  Buzz off.');
    }
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
