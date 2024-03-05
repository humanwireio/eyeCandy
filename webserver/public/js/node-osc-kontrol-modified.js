/*global jQuery, io, console, socket */
import patch_list from "../patch_list";

var oscControl = oscControl || {};

function getParameterByName(name, url) {
  if (!url) url = window.location.href;
  name = name.replace(/[\[\]]/g, "\\$&");
  var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
    results = regex.exec(url);
  if (!results) return null;
  if (!results[2]) return "";
  return decodeURIComponent(results[2].replace(/\+/g, " "));
}

(function ($) {
  "use strict";
  const patch_index = getParameterByName("index");
  oscControl.socket = io.connect();
  //set patch
  oscControl.socket.emit("patchselect", $("#patchselect")[0].className);

  Object.keys(patch_list).map((name) => {
    oscControl[name] = $(`.${name}`);
    oscControl[name].css("border", "5px solid white");
    const patch = patch_list[name];
    switch (patch.control_type) {
      case "fader":
        oscControl[name].bars({
          displayPrevious: true,
          min: 0,
          max: 127,
          fgColor: "#222222",
          bgColor: "#0000FF",
          width: screen.width,
          height: screen.height - 100,
          cursor: 40,
          change: (values) => {
            patch_list[getParameterByName("index")];
            oscControl.socket.emit(name, values);
          },
        });
      case "xy":
        oscControl[name].xy({
          displayPrevious: true,
          min: 0,
          max: 127,
          width: screen.width,
          height: screen.height - 100,
          fgColor: "#3299B7",
          bgColor: "rgba(0,0,0,5)",
          change: (values) => {
            oscControl.socket.emit(name, values);
          },
        });
    }
  });

  $("#patchselect").parent().hide();
})(jQuery);

setInterval(function () {
  oscControl.socket.emit("ping");
}, 3000);
