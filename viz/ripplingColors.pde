class ripplingColors extends patch{
 
  float[] wave;
  float[] waveColor;
  float len;
  int deform; 
  char drawShape;
  int roundedness;
  float randomness = 75;
  
  ripplingColors(){
    deform = 0;
    drawShape = 'r';
    roundedness = 0;
    //colors setup
    len = sqrt(sq(height) + sq(width))/2;
    wave = new float[int(len)];
    waveColor = new float[int(len)];
    for (int i = 0; i < int(len); i++) {
      float amount = map(i, 0, int(len), 0, 2*TWO_PI);
      wave[i] = abs(cos(amount));
      waveColor[i] = 0;
    }
    oscP5.plug(this,"update_red_weight","/0/fader1");
    oscP5.plug(this,"update_green_weight","/0/fader2");
    oscP5.plug(this,"update_blue_weight","/0/fader3");
    oscP5.plug(this,"update_deform","/0/fader4");
    oscP5.plug(this,"update_roundedness","/0/fader5");

  }
  
  void render(){
    pushMatrix();
    pushStyle();
    colorMode(RGB,255);
    noFill();
    deform = int(deform + random(-randomness, randomness));
    translate(IMG_WIDTH/2, IMG_HEIGHT/2);
    int stepSize = 3;
    for (int i = 0; i < int(len); i+=stepSize) {
      strokeWeight(stepSize);
      stroke(wave[i]*random(red_weight),wave[i]*random(green_weight),wave[i]*random(blue_weight), 60);
      int x = (i+deform)%IMG_WIDTH;
      int y = (i-deform)%IMG_HEIGHT;
      if (drawShape == 'e'){
        ellipse(0, 0, x, y);
      } else if (drawShape == 'r'){
        rectMode(CENTER);
        rect(0, 0, x, y, roundedness);
      }
   
    }
    shiftAndAdd(wave,wave[int(len)-1],10);
    popMatrix();
    popStyle();
  }
  
  void shiftAndAdd(float a[], float val, int numOfShifts){
    for (int i = 0; i < numOfShifts; i++) {
      int a_length = a.length;
      System.arraycopy(a, 0, a, 1, a_length-1);
      a[0] = val;
    }
  }
    
  void update_red_weight(int i) {
    red_weight = i*2;
    println("updating red weight to " + str(red_weight)); 
  }
  
  void update_green_weight(int i) {
    green_weight = i*2;
  }

  void update_blue_weight(int i) {
    blue_weight = i*2;
  }
  
  void update_deform(int d) {
    deform = int(map(d,0,127,-width, width));
  }
  
  void update_roundedness(int d) {
    roundedness = int(map(d,0,127,0,.4*displayHeight));
  }

}
