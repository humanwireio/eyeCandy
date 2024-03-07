const patch_list = {
  ripplingColors: {
    control_type: "fader",
    url: "ripplingColors.html",
    image: "/img/ripplingColorsButton.jpg",
    background: "/img/ripplingColorsBackground.jpg",
    defaultValue: [10, 30, 50, 70, 100],
    index: "ripplingColors",
  },
  daisies: {
    control_type: "xy",
    url: "daisies.html",
    image: "/img/daisiesButton.jpg",
    defaultValue: [0, 0],
    background: "/img/daisiesBackground.jpg",
    index: "daisies",
  },
  gameOfLife: {
    control_type: "xy",
    url: "gameOfLife.html",
    image: "/img/gameOfLifeButton.jpg",
    background: "/img/gameOfLifeBackground.jpg",
    index: "gameOfLife",
  },
  // ripples3D: {
  //  control_type: 'xy',
  //  url: 'ripples3D.html',
  //  image: '/img/ripples3DButton.jpg',
  //  background: '/img/ripples3DBackground.jpg',
  //  index: 'ripples3D'
  // },
  circs: {
    control_type: "xy",
    url: "circs.html",
    image: "/img/circsButton.jpg",
    background: "/img/circsBackground.jpg",
    index: "circs",
  },
  circFlash: {
    control_type: "xy",
    url: "circFlash.html",
    image: "/img/circFlashButton.jpg",
    background: "/img/cirFlashBackground.jpg",
    index: "circFlash",
  },
  streakfire: {
    control_type: "xy",
    url: "streakfire.html",
    image: "/img/circFlashButton.jpg",
    // image: '/img/streakfireButton.jpg',
    index: "streakfire",
  },
  // shader: {
  //   control_type: "xy",
  //   url: "shader1.html",
  //   image: "/img/shader1Button.jpg",
  //   index: 7,
  // },
  // shader2: {
  //   control_type: 'xy',
  //   url: 'shader2.html',
  //   image: '/img/shader2Button.jpg',
  //   index: 8
  // },
  // shader3: {
  //   control_type: 'xy',
  //   url: 'shader3.html',
  //   image: '/img/shader3Button.jpg',
  //   index: 9
  // },
  // camBlobs: {
  //  control_type: 'xy',
  //  url: 'camBlobs.html',
  //  image: '/img/camBlobsButton.jpg',
  //  index: 'camBlobs'
  // },
  // moveVolBlobs: {
  //  control_type: 'xy',
  //  url: 'moveVol.html',
  //  image: '/img/moveVolButton.jpg',
  //  index: 'moveVolBlobs'
  // },
  auto: {
    control_type: "xy",
    index: -1,
  },
  off: {
    control_type: "",
    index: -1,
  },
};

if (typeof module != "undefined") {
  module.exports = patch_list;
} else {
  window.patch_list = patch_list;
}
