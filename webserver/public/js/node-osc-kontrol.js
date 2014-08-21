/*global jQuery, io, console, socket */

var oscControl = oscControl || {};

(function ($) {
    'use strict';
    oscControl.socket = io.connect();
    //set patch
    oscControl.socket.emit('patchselect', $('#patchselect')[0].className)
    
    oscControl.ripplingColors = $(".ripplingColors");//
    oscControl.ripplingColors.bars({
        displayPrevious: false,
        min: 0,
        max: 127,
        fgColor: "#222222",
        bgColor: "#000000",
        change: function (values) {
            oscControl.socket.emit('ripplingColors', values);
        }
    });

    oscControl.daisies = $(".daisies");//
    oscControl.daisies.xy({
        displayPrevious: true,
        min: 0,
        max: 127,
        fgColor: "#3299B7",
        bgColor: "rgba(0,0,0,.5)",
        change: function (values) {
            oscControl.socket.emit('daisies', values);
        }
    });

}(jQuery));

setInterval(function(){
    oscControl.socket.emit('ping')
}, 3000);
