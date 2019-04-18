const patch_list = {
  ripplingColors: {
   control_type: 'fader',
   url: 'ripplingColors.html',
   image: '/img/ripplingColorsButton.jpg',
   background: '/img/ripplingColorsBackground.jpg',
   defaultValue: [10, 30, 50, 70, 100],
   index: 0
  },
  daisies: {
   control_type: 'xy',
   url: 'daisies.html',
   image: '/img/daisiesButton.jpg',
   defaultValue: [0, 0],
   background: '/img/daisiesBackground.jpg',
   index: 1
  },
  gameOfLife: {
   control_type: 'xy',
   url: 'gameOfLife.html',
   image: '/img/gameOfLifeButton.jpg',
   background: '/img/gameOfLifeBackground.jpg',
   index: 2
  },
  ripples3D: {
   control_type: 'xy',
   url: 'ripples3D.html',
   image: '/img/ripples3DButton.jpg',
   background: '/img/ripples3DBackground.jpg',
   index: 3
  },
  circs: {
   control_type: 'xy',
   url: 'circs.html',
   image: '/img/circsButton.jpg',
   background: '/img/circsBackground.jpg',
   index: 4
  },
  circFlash: {
   control_type: 'xy',
   url: 'circFlash.html',
   image: '/img/circFlashButton.jpg',
   index: 5
  },
  streakfire: {
    control_type: 'xy',
    url: 'streakfire.html',
    image: '/img/streakfireButton.jpg',
    index: 6
  },
  shader1: {
    control_type: 'xy',
    url: 'shader1.html',
    image: '/img/shader1Button.jpg',
    index: 7
  },
  shader2: {
    control_type: 'xy',
    url: 'shader2.html',
    image: '/img/shader2Button.jpg',
    index: 8
  },
  shader3: {
    control_type: 'xy',
    url: 'shader3.html',
    image: '/img/shader3Button.jpg',
    index: 9
  },
  // camBlobs: {
  //  control_type: 'xy',
  //  url: 'camBlobs.html',
  //  image: '/img/camBlobsButton.jpg',
  //  index: 6
  // },
  // moveVolBlobs: {
  //  control_type: 'xy',
  //  url: 'moveVol.html',
  //  image: '/img/moveVolButton.jpg',
  //  index: 7
  // },
  auto: {
   control_type: 'xy',
   index: -1
  },
  off: {
   control_type: '',
   index: -1
  }
}

if (module){
  module.exports = patch_list
} else {
  window.patch_list = patch_list
}
