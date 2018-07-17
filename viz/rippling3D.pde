class rippling3D extends patch{
 
  float[] wave;
  float[] waveColor;
  float len;
  int red_weight;
  int green_weight;
  int blue_weight;
  int deform; 
  char drawShape;
  int roundedness;
    
  rippling3D(){
    red_weight = 1;
    green_weight = 1;
    blue_weight = 1;
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
    oscP5.plug(this,"update_red","/1/fader1");
    oscP5.plug(this,"update_green","/1/fader2");
    oscP5.plug(this,"update_blue","/1/fader3");
    oscP5.plug(this,"update_deform","/1/fader5");
    oscP5.plug(this,"update_roundedness","/1/fader4");
  }
  
  void render(){
    pushMatrix();
    pushStyle();
    colorMode(RGB,255);
    noFill();
    translate(IMG_WIDTH/2, IMG_HEIGHT/2);
    int stepSize = 3;
    for (int i = 0; i < int(len); i+=stepSize) {
      strokeWeight(stepSize);
      stroke(wave[i]*random(red_weight),wave[i]*random(green_weight),wave[i]*random(blue_weight));
      int x = (i+deform)%IMG_WIDTH;
      int y = (i-deform)%IMG_HEIGHT;
      if (drawShape == 'e'){
        ellipse(0, 0, x, y);
      } else if (drawShape == 'r'){
        box(x,y,int(x*y/2));
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
  
  void update_red(float r) {
    red_weight = int(r*255);
  }
  
  void update_green(float g) {
    green_weight = int(g*255);
  }
  
  void update_blue(float b) {
    blue_weight = int(b*255);
  }
  
  void update_deform(float d) {
    deform = int((d-.5)*width*3);
  }
  
  void update_roundedness(float d) {
    roundedness = int(d*.5*displayHeight);
  }
 
}
