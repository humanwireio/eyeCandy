/*global jQuery, io, console, socket */

var oscControl = oscControl || {};

(function ($) {
    'use strict';
    oscControl.socket = io.connect();
    //set patch
    oscControl.socket.emit('patchselect', $('#patchselect')[0].className)
    
    oscControl.ripplingColors = $(".ripplingColors");//
    oscControl.ripplingColors.css("border","5px solid white");
    oscControl.ripplingColors.bars({
        displayPrevious: true,
        min: 0,
        max: 127,
        fgColor: "#222222",
        bgColor: "#0000FF",
        width: screen.width,
        height: screen.height-100,
        cursor: 40,
        change: function (values) {
            oscControl.socket.emit('ripplingColors', values);
        }
    });

    oscControl.daisies = $(".daisies");//
    oscControl.daisies.css("border","5px solid white");
    oscControl.daisies.xy({
        displayPrevious: true,
        min: 0,
        max: 127,
        width: screen.width,
        height: screen.height-100,
        fgColor: "#3299B7",
        bgColor: "rgba(0,0,0,5)",
        change: function (values) {
            oscControl.socket.emit('daisies', values);
        }
    });

    oscControl.gameOfLife = $(".gameOfLife");//
    oscControl.gameOfLife.xy({
        displayPrevious: true,
        min: 0,
        max: 127,
        fgColor: "#3299B7",
        bgColor: "rgba(0,0,0,.5)",
        change: function (values) {
            oscControl.socket.emit('gameOfLife', values);
        }
    });

}(jQuery));

setInterval(function(){
    oscControl.socket.emit('ping')
}, 3000);
