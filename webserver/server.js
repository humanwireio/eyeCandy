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
    var ip  = socket.handshake.address;
    console.log('ip:', ip);

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
        switch (patchName) {
            case "ripplingColors":
                {client.send("/1", ip)}
            case "daisies":
                {client.send("/3", ip)}
            case "ripples3D":
                {client.send("/2", ip)}
            case "gameOfLife":
                {client.send("/4", ip)}
            case "caliSunset":
                {client.send("/5", ip)}
            case "circs":
                {client.send("/6", ip)}
            case "off":
                {client.send("/9", ip)}
        }
    });

    socket.on('ping', function() {
        console.log('ping')
        var ip  = socket.handshake.address['address'];
        client.send("/ping", ip);
    });

});
