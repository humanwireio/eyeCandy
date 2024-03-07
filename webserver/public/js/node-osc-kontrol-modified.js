/*global jQuery, io, console, socket */
const urlParams = new URLSearchParams(window.location.search);
const patchName = document.getElementById("patchselect").getAttribute("class");
var oscControl = oscControl || {};

(function ($) {
  "use strict";
  oscControl.socket = io.connect();
  //set patch
  if (patchName) {
    oscControl.socket.emit("patchselect", patchName);
  } else {
    Object.keys(patch_list).map((name) => {
      oscControl[name] = $(`.${name}`);
      oscControl[name].css("border", "5px solid white");
      const patch = patch_list[name];
      const common_options = {
        displayPrevious: true,
        min: 0,
        max: 127,
        width: screen.width,
        height: screen.height - 100,
        change: (values) => {
          oscControl.socket.emit(name, values);
        },
      };
      switch (patch.control_type) {
        case "fader":
          oscControl[name].bars(
            Object.assign({}, common_options, {
              fgColor: "#222222",
              bgColor: "#0000FF",
              cursor: 40,
              change: (values) => {
                oscControl.socket.emit(name, values);
              },
            }),
          );
        case "xy":
          oscControl[name].xy(
            Object.assign({}, common_options, {
              fgColor: "#3299B7",
              bgColor: "rgba(0,0,0,5)",
              change: (values) => {
                oscControl.socket.emit(name, values);
              },
            }),
          );
      }
    });
  }

  $("#patchselect").parent().hide();
})(jQuery);

setInterval(function () {
  oscControl.socket.emit("ping");
}, 3000);
