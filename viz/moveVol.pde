class MoveVol extends patch{

  Minim       minim;
  AudioInput in;
  BeatDetect beat;
  int numPixels;
  int[] previousFrame;
  private PApplet app;
  
  
  MoveVol(PApplet app) {
    this.app = app;
    minim = new Minim(this);
    in = minim.getLineIn(Minim.STEREO, 512);
    beat = new BeatDetect();
  
    // This the default video input, see the GettingStartedCapture 
    // example if it creates an error

    numPixels = video.width * video.height;
    // Create an array to store the previously captured frame
    previousFrame = new int[numPixels];
    loadPixels();
  }

  void render() {
     beat.detect(in.mix);
     if (video.available()) {
      // When using video to manipulate the screen, use video.available() and
      // video.read() inside the draw() method so that it's safe to draw to the screen
      video.read(); // Read the new frame from the camera
      video.loadPixels(); // Make its pixels[] array available
      
      int movementSum = 0; // Amount of movement in the frame
      for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
        color currColor = video.pixels[i];
        color prevColor = previousFrame[i];
        // Extract the red, green, and blue components from current pixel
        int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
        int currG = (currColor >> 8) & 0xFF;
        int currB = currColor & 0xFF;
        // Extract red, green, and blue components from previous pixel
        int prevR = (prevColor >> 16) & 0xFF;
        int prevG = (prevColor >> 8) & 0xFF;
        int prevB = prevColor & 0xFF;
        // Compute the difference of the red, green, and blue values
        int diffR = abs(currR - prevR);
        int diffG = abs(currG - prevG);
        int diffB = abs(currB - prevB);
        // Add these differences to the running tally
        movementSum += diffR + diffG + diffB;
        // Set transparency based on minim sound energy
        int opacity;
        diffG = int(diffG * .25);
        if (this.isBeat()) {
          opacity = 125;
          diffB = int(random(0, 0.5) * diffB);
        } else {
          opacity = 5;
          diffR = int(random(0, 0.5) * diffR);
          }
        // Render the difference image to the screen
        pixels[i] = color(diffR, diffG, diffB, opacity);
        // The following line is much faster, but more confusing to read
        //pixels[i] = 0xff000000 | (diffR << 16) | (diffG << 8) | diffB;
        // Save the current color into the 'previous' buffer
        previousFrame[i] = currColor;
      }
      // To prevent flicker from frames that are all black (no movement),
      // only update the screen if the image has changed.
      if (movementSum > 0) {
        updatePixels();
        println(movementSum); // Print the total amount of movement to the console
      }
    }
  }
  
  boolean isBeat(){
    return beat.isOnset();
  }
}
