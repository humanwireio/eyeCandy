const lodash = require('lodash');

var app = require('express')()
    , server = require('http').createServer(app)
    , io = require('socket.io').listen(server)
    , osc = require('node-osc')
    , client = new osc.Client('127.0.0.1', 12000);

server.listen(8080);

app.get('/', function (req, res) {
  res.sendFile(__dirname + '/public/index.html');
});

app.get('/*.(js|css|jpg|html)', function(req, res){
  res.sendFile(__dirname + "/public" + req.url);
});

io.sockets.on('connection', function (socket) {
    socket.on('daisies', function (data) {
        console.log(data);
        client.send("/3/xy", data[0]), data[1];
    });

    socket.on('ripplingColors', function(data) {
        console.log(data);
        //determine which slider
        for(var k in data) var key=k;
        k_lite = parseInt(k)+1;
        client.send("/1/fader"+k_lite, data[k]);
    });

    socket.on('daisies', function (data) {
        console.log(data);
        client.send("/3/xy", data[0], data[1]);
    });

    socket.on('patchselect', function(patchName) {
        var ip  = socket.handshake.address;
        console.log('ip:', ip);
        if (patchName == "ripplingColors")
            {client.send("/1", ip)}
        else if (patchName == "daisies")
            {client.send("/3", ip)}
        else if (patchName == "ripples3D")
            {client.send("/2", ip)}
        else if (patchName == "gameOfLife")
            {client.send("/4", ip)}
        else if (patchName == "caliSunset")
            {client.send("/5", ip)}
        else if (patchName =="circs")
            {client.send("/6", ip)}
        else if (patchName == "off")
            {client.send("/9", ip)}
    });

    socket.on('ping', function() {
        var ip  = socket.handshake.address['address'];
        client.send("/ping", ip);
    });

});
