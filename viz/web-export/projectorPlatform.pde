//import statements
import deadpixel.keystone.*;

Keystone ks;
CornerPinSurface surface;

PGraphics offscreen;


//Trippy parameters
boolean mirror = true;

// OpenCV instance
OpenCV opencv;

PImage lastAbsDiff; 

int threshold = 80;

// image dimensions
final int IMG_WIDTH = 1280;
final int IMG_HEIGHT = 720;

// work with which color space
final int COLOR_SPACE = OpenCV.RGB;

int diff_times = 1;

//colors parameters
float[] wave;
float[] waveColor;
float len;
int red_weight = 1;
int green_weight = 1;
int blue_weight = 1;
int deform = 0; 
char drawShape = 'r';
int roundedness = 0;
import oscP5.*;
import netP5.*;

OscP5 oscP5;

boolean do_colors = false;
boolean do_trippy = false;
boolean do_fft_circles = true;

void setup(){
  //trippy's setup
  size(IMG_WIDTH,IMG_HEIGHT, P3D);
  
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(IMG_WIDTH, IMG_HEIGHT, 20);
  offscreen = createGraphics(IMG_WIDTH, IMG_HEIGHT, P3D);

  opencv = new OpenCV(this);
  opencv.capture(IMG_WIDTH, IMG_HEIGHT);
  
  opencv.remember();
  
  lastAbsDiff = opencv.image();
  cursor(CROSS);
  
  //colors setup
  len = sqrt(sq(height) + sq(width))/2;
  wave = new float[int(len)];
  waveColor = new float[int(len)];
  for (int i = 0; i < int(len); i++) {
    float amount = map(i, 0, int(len), 0, 2*TWO_PI);
    wave[i] = abs(cos(amount));
    waveColor[i] = 0;
  }



  background(0);
  
  oscP5 = new OscP5(this,12000);
  oscP5.plug(this,"update_red","/1/fader1");
  oscP5.plug(this,"update_green","/1/fader2");
  oscP5.plug(this,"update_blue","/1/fader3");
  oscP5.plug(this,"update_deform","/1/fader5");
  oscP5.plug(this,"update_roundedness","/1/fader4");
  oscP5.plug(this,"update_do_colors","/1/toggle1");
  oscP5.plug(this,"update_do_trippy","/1/toggle2");
  oscP5.plug(this,"update_do_fft_circles","/1/toggle3");
  //oscP5.plug(this,"saveImage","/1/toggle4");
  
  //frameRate(8);
}

void draw(){
  
  PVector surfaceMouse = surface.getTransformedMouse();
  
  // Draw the scene, offscreen
  offscreen.beginDraw();

  if (do_trippy) {
    //trippy draw
      //get absDiff() with current image
    opencv.read();
    for (int i=0; i<diff_times; i++){
      opencv.absDiff();
    }
    
    
    if (mirror){
      opencv.flip(opencv.FLIP_HORIZONTAL);
    }
      
    offscreen.image(opencv.image(), IMG_WIDTH, IMG_HEIGHT);
    blend(lastAbsDiff,0,0,IMG_WIDTH,IMG_HEIGHT,0,0,IMG_WIDTH,IMG_HEIGHT,SUBTRACT);
    opencv.remember();
    
    opencv.threshold(threshold);
    
    //blob detect
    Blob[] blobs = opencv.blobs( 10, IMG_WIDTH*IMG_HEIGHT/2, 100, true, OpenCV.MAX_VERTICES*4 );
    // draw blob results
      for( int i=0; i<blobs.length; i++ ) {
          offscreen.fill(random(red_weight),random(green_weight),random(blue_weight));
          offscreen.beginShape();
          for( int j=0; j<blobs[i].points.length; j++ ) {
              offscreen.vertex( blobs[i].points[j].x, blobs[i].points[j].y );
          }
          offscreen.endShape(CLOSE);
      }
      
      if (mirror){
        opencv.flip(opencv.FLIP_HORIZONTAL);
      }
  }
    
  offscreen.stroke(random(red_weight),random(green_weight),random(blue_weight));
      
  if (do_colors) {    //color draw
    offscreen.noFill();
    offscreen.translate(IMG_WIDTH/2, IMG_HEIGHT/2);
    int stepSize = 3;
    for (int i = 0; i < int(len); i+=stepSize) {
      offscreen.strokeWeight(stepSize);
      offscreen.stroke(wave[i]*random(red_weight),wave[i]*random(green_weight),wave[i]*random(blue_weight));
      int x = (i+deform)%IMG_WIDTH;
      int y = (i-deform)%IMG_HEIGHT;
      if (drawShape == 'e'){
        offscreen.ellipse(0, 0, x, y);
      } else if (drawShape == 'r'){
        offscreen.rectMode(CENTER);
        offscreen.rect(0, 0, x, y, roundedness);
      }
   
    }
    shiftAndAdd(wave,wave[int(len)-1],10);
  }
  
  if (do_fft_circles){

  }
  
  offscreen.endDraw();
  surface.render(offscreen);
}


//trippy functions
void mouseDragged() {
    threshold = int( map(mouseX,0,width,0,255) );
    diff_times = int( map(mouseY,0,height,1,3) );
}

void keyPressed() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    offscreen.background(0);
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;
    
  }
}

void saveImage(float whoCares){
  saveImage();
}

void saveImage() {
    int h = hour();
    int m = minute();
    int s = second();
    String time_string = String.valueOf(h) + "_" + String.valueOf(m) + "_" + String.valueOf(s);
    save("out" + time_string + ".png");
} 

//color functions
void update_do_colors(float b){
 if (b==1){
   do_colors = true;
 }else{
   do_colors = false;
 }
}

void update_do_trippy(float b){
 if (b==1){
   do_trippy = true;
 }else{
   do_trippy = false;
 }
}

void update_do_fft_circles(float b){
 if (b==1){
   do_fft_circles = true;
 }else{
   do_fft_circles = false;
 }
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
  //and code to edit threshold for cam stuff
  threshold = int( map(d,0,1,0,255) );
  
}

void update_roundedness(float d) {
  roundedness = int(d*.5*displayHeight);
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* with theOscMessage.isPlugged() you check if the osc message has already been
   * forwarded to a plugged method. if theOscMessage.isPlugged()==true, it has already 
   * been forwared to another method in your sketch. theOscMessage.isPlugged() can 
   * be used for double posting but is not required.
  */  
  if(theOscMessage.isPlugged()==false) {
  /* print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message.");
  println("### addrpattern\t"+theOscMessage.addrPattern());
  println("### typetag\t"+theOscMessage.typetag());
  }
}

void stop()
{
  // always close Minim audio classes when you finish with them
  in.close();
  minim.stop();
  
  super.stop();
}

import ddf.minim.analysis.*;
import ddf.minim.*;

class fft_circles {
  
  Minim minim;
  AudioInput in;
  FFT fft;
  String windowName;
 
  fft_circles() {
    //sound setup
    minim = new Minim(this);
    in = minim.getLineIn(Minim.STEREO, 512);
    fft = new FFT(in.bufferSize(), in.sampleRate());
    windowName = "None";
  }
  
  void update() {
    offscreen.stroke(random(red_weight),random(green_weight),random(blue_weight));
    int CircleThickness = 4;
    offscreen.strokeWeight(2*CircleThickness);
    offscreen.fill(0);
    // perform a forward FFT on the samples in jingle's left buffer
    // note that if jingle were a MONO file, 
    // this would be the same as using jingle.right or jingle.left
    fft.forward(in.mix);
    for(int i = 0; i < fft.specSize(); i++)
    {
      // draw the line for frequency band i, scaling it by 4 so we can see it a bit better
      float current_stroke = fft.getBand(fft.specSize()-i)*250;
      offscreen.stroke(random(current_stroke*red_weight)/10,random(current_stroke*green_weight)/10,random(current_stroke*blue_weight)/10);
      offscreen.ellipse(int(width/2), int(height/2),i*CircleThickness,i*CircleThickness);
    }
  }
      
  
}


  
import hypermedia.video.*;
import java.awt.*;



