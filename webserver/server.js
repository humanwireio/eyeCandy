var _ = require("underscore");
var app = require('express')()
    , server = require('http').createServer(app)
    , io = require('socket.io').listen(server)
    , osc = require('node-osc')
    , clients = [new osc.Client('192.168.1.30', 12000),
     new osc.Client('192.168.1.113', 12000)];

var quite = true;

server.listen(80);

app.get('/', function (req, res) {
  res.sendfile(__dirname + '/public/index.html');
});

app.get('/*.(js|css|jpg|html)', function(req, res){
  res.sendfile("./public"+req.url);
});

io.sockets.on('connection', function (socket) {

    socket.on('ripplingColors', function(data) {
        //console.log(data);
        //determine which slider
        for(var k in data) var key=k;
        k_lite = parseInt(k)+1;
        _.each(clients,function(c){c.send("/1/fader"+k_lite, data[k])});
    });

    socket.on('daisies', function (data) {
        if (!quite){
            console.log(data);
        }
        _.each(clients,function(c){c.send("/3/xy", data[0], data[1])});
    });

    socket.on('circflash', function (data) {
        if (!quite){
            console.log(data);
        }
        _.each(clients,function(c){c.send("/7/xy", data[0], data[1])});
    });

    socket.on('camBlobs', function (data) {
        if (!quite){
            console.log(data);
        }
        _.each(clients,function(c){c.send("/8/xy", data[0], data[1])});
    });

    socket.on('gameOfLife', function (data) {
        if (!quite){
            console.log(data);
        }
        _.each(clients,function(c){c.send("/4/xy", data[0], data[1])});
    });

    socket.on('patchselect', function(patchName) {
        var ip  = socket.handshake.address['address'];
        if (!quite){
            console.log(ip);
        }
        if (patchName == "ripplingColors")
            {_.each(clients,function(c){c.send("/1", ip)})}
        else if (patchName == "ripples3D")
            {_.each(clients,function(c){c.send("/2", ip)})}
        else if (patchName == "daisies")
            {_.each(clients,function(c){c.send("/3", ip)})}
        else if (patchName == "gameOfLife")
            {_.each(clients,function(c){c.send("/4", ip)})}
        else if (patchName =="circs")
            {_.each(clients,function(c){c.send("/5", ip)})}
        else if (patchName =="auto")
            {_.each(clients,function(c){c.send("/6", ip)})}
        else if (patchName =="circFlash")
            {_.each(clients,function(c){c.send("/7", ip)})}
        else if (patchName == "camBlobs")
            {_.each(clients,function(c){c.send("/8", ip)})}
        else if (patchName == "off")
            {_.each(clients,function(c){c.send("/9", ip)})}
    });

    socket.on('ping', function() {
        var ip  = socket.handshake.address['address'];
        _.each(clients,function(c){c.send("/ping", ip)});
    });

});
