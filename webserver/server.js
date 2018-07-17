var patch_list = require('./public/patch_list')
var _ = require("lodash");
var app = require('express')();
var server = require('http').Server(app);
var io = require('socket.io')(server);
var osc = require('node-osc')
var clients = [new osc.Client('localhost', 12000)]
//    , clients = [new osc.Client('192.168.0.103', 12000),
//    new osc.Client('192.168.1.112', 12000)];

// server.listen(8080);
server.listen({
  // host: 'localhost',
  port: 8080,
  exclusive: true
});

app.get('/', function (req, res) {
  console.log("app got '/' request")
  res.sendFile(__dirname + '/public/index.html');
});

app.get('/*.(js|css|jpg|html)', function(req, res){
  res.sendFile(__dirname + "/public" + req.url);
});

io.on('connection', function (socket) {
  // console.log('connection event, socket:', socket)
   _.keys(patch_list).forEach((k, i) => {
     console.log('about to setup event handler for k:', k)
     socket.on(k, data => {
       console.log('data:', data)
       const index = _.keys(data)[0]
       console.log('patch_list[k]:', patch_list[k])
       const patch_type = patch_list[k].control_type
       switch (patch_type) {
         case 'fader':
           console.log(data);
           //determine which slider
           // for(var k in data) var key=k;
           const ind_lite = parseInt(index)+1;
           _.each(clients,function(c){c.send(`/${i}/fader`+ind_lite, data[index])});
           break
         case 'xy':
           _.each(clients,function(c){c.send(`/${i}/xy`, data[0], data[1])});
       }
     })
   })

   socket.on('patchselect', function(patchName) {
       console.log('socket.handshake.address:', socket.handshake.address)
       var ip = socket.handshake.address;
       console.log('ip:', ip);
       path_ind = _.keys(patch_list).indexOf(patchName)
       if (path_ind != -1){
         _.each(clients, c => c.send(`/${path_ind}/`, ip))
       }
   });

   socket.on('ping', function() {
       var ip  = socket.handshake.address['address'];
       _.each(clients,function(c){c.send("/ping", ip)});
   });

});

    // socket.on('ripplingColors', function(data) {
    //     console.log(data);
    //     //determine which slider
    //     for(var k in data) var key=k;
    //     k_lite = parseInt(k)+1;
    //     _.each(clients,function(c){c.send("/1/fader"+k_lite, data[k])});
    // });
    //
    // socket.on('daisies', function (data) {
    //     if (!quite){
    //         console.log('data:', data);
    //     }
    //     _.each(clients,function(c){c.send("/3/xy", data[0], data[1])});
    // });
    //
    // socket.on('circflash', function (data) {
    //     if (!quite){
    //       console.log('data:', data);
    //     }
    //     _.each(clients,function(c){c.send("/7/xy", data[0], data[1])});
    // });
    //
    // socket.on('camBlobs', function (data) {
    //     if (!quite){
    //       console.log('data:', data);
    //     }
    //     _.each(clients,function(c){c.send("/8/xy", data[0], data[1])});
    // });
    //
    // socket.on('gameOfLife', function (data) {
    //     if (!quite){
    //       console.log('data:', data);
    //     }
    //     _.each(clients,function(c){c.send("/4/xy", data[0], data[1])});
    // });
