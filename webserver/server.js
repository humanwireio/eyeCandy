var patch_list = require("./public/patch_list");
var app = require("express")();
var server = require("http").Server(app);
var io = require("socket.io")(server);
var osc = require("node-osc");
var clients = [new osc.Client("localhost", 12000)];
var Handlebars = require("handlebars");
const fs = require("fs");

server.listen({
  // host: 'localhost',
  port: 8080,
  exclusive: true,
});

app.get("/", (req, res) => {
  console.log("app got '/' request");
  res.sendFile(__dirname + "/public/index.html");
});

app.get("/*.(js|css|jpg|html)", function (req, res) {
  res.sendFile(__dirname + "/public" + req.url);
});

Object.keys(patch_list).forEach((name) => {
  app.get(`/${name}`, (req, res) => {
    patch = patch_list[name];
    template = Handlebars.compile(
      fs
        .readFileSync(__dirname + `/public/${patch.control_type}.tmpl`)
        .toString(),
    );
    const data = template({ patch: name });
    res.send(data);
  });
});

io.on("connection", function (socket) {
  // console.log('connection event, socket:', socket)
  Object.keys(patch_list).forEach((k, i) => {
    socket.on(k, (data) => {
      console.log("data:", data);
      console.log("patch_list[k]:", patch_list[k]);
      const { control_type, index } = patch_list[k];
      switch (control_type) {
        case "fader":
          console.log(data);
          const fader_index = Object.keys(data)[0];
          //determine which slider
          const ind_lite = parseInt(fader_index) + 1;
          clients.forEach((c) => {
            c.send(`/${index}/fader` + ind_lite, data[fader_index]);
          });
          break;
        case "xy":
          clients.forEach((c) => {
            c.send(`/${index}/xy`, data[0], data[1]);
          });
      }
    });
  });

  socket.on("patchselect", function (patchName) {
    console.log("---patchselect---");
    console.log("socket.handshake.address:", socket.handshake.address);
    console.log("patchName:", patchName);
    var ip = socket.handshake.address;
    console.log("ip:", ip);
    clients.forEach((c) => c.send(`/${patchName}/`, ip));
  });

  socket.on("ping", function () {
    var ip = socket.handshake.address["address"];
    if (ip) {
      console.log("ip", ip);
      clients.forEach((c) => {
        c.send("/ping", ip);
      });
    }
  });
});
