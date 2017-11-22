var express = require('express');
var app = express();

var helloController = require('./controllers/helloController');

var port = process.env.PORT || 3000;
var host = process.env.HOST || '0.0.0.0';


helloController(app);
app.listen(port, host);

console.log(`Running on http://${host}:${port}`);