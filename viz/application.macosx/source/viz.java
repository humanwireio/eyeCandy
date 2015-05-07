import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 
import ddf.minim.analysis.*; 
import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class viz extends PApplet {



  
OscP5 oscP5;

// image dimensions
final int IMG_WIDTH = 1280;
final int IMG_HEIGHT = 720;

//device management
IntDict dev_timers;
IntDict dev_patches;

//patches
//circle circ;
ripplingColors rc;
rippling3D r3D;
daisies da;
gameOfLife gol;
FFTCircles circs;
ArrayList<patch> patches;
ArrayList<Boolean> patch_switch;

//random color weights
float red_weight = .5f;
float green_weight = .5f;
float blue_weight = .5f;

public void setup(){
  size(IMG_WIDTH,IMG_HEIGHT, P3D);
  oscP5 = new OscP5(this,12000);
  dev_patches = new IntDict();
  dev_timers = new IntDict();
  patches = new ArrayList<patch>();
  patch_switch = new ArrayList<Boolean>();
 
  for (int i=0; i < 6; i++) {
    patch_switch.add(false);
  }
  patch_switch.set(3,true);
  rc = new ripplingColors();
  r3D = new rippling3D();
  da = new daisies(this);
  gol = new gameOfLife(this);
  circs = new FFTCircles(this);
  patches.add(rc);
  patches.add(r3D);
  patches.add(da);
  patches.add(gol);
  patches.add(circs);
 
  oscP5.plug(this,"pinged","/ping");
//  oscP5.plug(this,"update_red_weight","/1/fader1");
//  oscP5.plug(this,"update_green_weight","/1/fader2");
//  oscP5.plug(this,"update_blue_weight","/1/fader3");

  noCursor();
}

public void draw(){
  timeout_check();
  //background(0);
//  red_weight = int(random(255));
//  green_weight = int(random(255));
//  blue_weight = int(random(255));
  draw_connection_info();

  for (int i=0; i<patches.size(); i++){
   if (patch_switch.get(i)){
     //println(patch_switch);
     patch p = patches.get(i);
     p.render(); 
   }
  }

  draw_connection_info();
  
  reset_patch_switch();
  for (int i : dev_patches.values()) {
    patch_switch.set((i-1), true);
  }
  
}

public void draw_connection_info(){
  String connection_info = "Connect to Wifi: visuals, Go to Address 192.168.1.112 in your browser address bar";
  int text_size = 24;
  colorMode(RGB,100);
  fill(0,100);
  stroke(0,100);
  rect(0,0,connection_info.length()*text_size,2*text_size);
  fill(100,100);
  textAlign(LEFT,TOP);
  textSize(text_size);
  text(connection_info,0,0);
}

public void reset_patch_switch() {
  for (int i=0; i < patch_switch.size(); i++) {
    patch_switch.set(i,false);
  } 
}
public void pick_single_patch(ArrayList<Boolean> patch_swtich, int num){
  for (int i=0; i < patch_switch.size(); i++) {
    if (i==num) {
      patch_switch.set(i,true);
    } else {
      patch_swtich.set(i,false);
    }
  }
}
/* incoming osc message are forwarded to the oscEvent method. */
public void oscEvent(OscMessage theOscMessage) {
  /* with theOscMessage.isPlugged() you check if the osc message has already been
   * forwarded to a plugged method. if theOscMessage.isPlugged()==true, it has already 
   * been forwared to another method in your sketch. theOscMessage.isPlugged() can 
   * be used for double posting but is not required.
  */
 String ip = theOscMessage.get(0).stringValue();
// dev_timers.set(ip, millis());
 println("IP: " + ip);
 //println("addrPattern: " + theOscMessage.addrPattern());
 if(theOscMessage.isPlugged()==false) {
   if (theOscMessage.addrPattern().length() == 2) {
     try {
        int patch_num = PApplet.parseInt(str(theOscMessage.addrPattern().charAt(1)));
          
        println("IP: " +  ", Patch_num: " + str(patch_num));
        //device management
        if (patch_num==9){
          dev_timers.remove(ip);
          dev_patches.remove(ip);
        } else {
          dev_patches.set(ip,patch_num);
          dev_timers.set(ip, millis());
        }
      
      } catch (Exception e) {
        println("error parsing patch code");
      }

      
   } else {
        /* print the address pattern and the typetag of the received OscMessage */
        println("### received an osc message.");
        println("### addrpattern\t"+theOscMessage.addrPattern());
        println("### typetag\t"+theOscMessage.typetag());
        println("### netaddress"+theOscMessage.netaddress());
  }
 }
 
}

public void timeout_check(){
  if (dev_patches.size()>1){
    for (String ip : dev_timers.keys()){
      if ((millis()-dev_timers.get(ip))>10000){
        dev_timers.remove(ip);
        dev_patches.remove(ip);
        println(ip + " timedout");
      }
    }
  }
}

public void pinged(String ip){
  dev_timers.set(ip,millis());
}

public void mouseDragged(){
  println("mouseX: " + mouseX);
  println("mouseY: " + mouseY);
  da.mouseDragged();
}

public boolean sketchFullScreen() {
  return true;
}

public static void main(String[] args) { 
  PApplet.main(new String[]{ "--hide-stop", viz.class.getName() });
}



class FFTCircles extends patch{
  
  Minim minim;
  AudioInput in;
  FFT fft;
  String windowName;
  private PApplet app;
  
  FFTCircles(PApplet app){
    this.app = app;
    //sound setup
    minim = new Minim(app);
    in = minim.getLineIn(Minim.STEREO, 512);
    fft = new FFT(in.bufferSize(), in.sampleRate());
    windowName = "None";
  }
  
  public void render(){
    colorMode(RGB, 255);
    stroke(random(red_weight),random(green_weight),random(blue_weight), 30);
    int CircleThickness = 4;
    strokeWeight(2*CircleThickness);
    noFill();
    // perform a forward FFT on the samples in jingle's left buffer
    // note that if jingle were a MONO file, 
    // this would be the same as using jingle.right or jingle.left
    fft.forward(in.mix);
    for(int i = 0; i < fft.specSize(); i++)
    {
      // draw the line for frequency band i, scaling it by 4 so we can see it a bit better
      float current_stroke = fft.getBand(fft.specSize()-i)*250;
      if (current_stroke > 50){
        stroke(random(current_stroke*red_weight)/10,random(current_stroke*green_weight)/10,random(current_stroke*blue_weight)/10, 30);
        ellipse(PApplet.parseInt(width/2), PApplet.parseInt(height/2),i*CircleThickness,i*CircleThickness);
      }
    }
  }
  
}

class daisies extends patch{
  //Diasies From Mathographics book by Robert Dixon pg 131
  float K = 5;
  float C = 360/222.49f;
  float prevK = 5;
  float prevC = 360/222.49f;
  float D = TWO_PI/C;
  //float D = 74/C;
  float R;
  float RR = 5;
  private PApplet app;
  boolean do_colors = false;
  float amount_of_randomness = .005f;
  
  daisies(PApplet app){
    this.app = app;
    //fill(255);
    //oscP5.plug(this,"updateK","/1/fader1");
    //oscP5.plug(this,"updateC","/1/fader2");
    oscP5.plug(this,"update","/3/xy");
    oscP5.plug(this,"update_do_colors","/3/toggle1");
    oscP5.plug(this,"updateD","/1/fader1");
  }

  public void render() {
    add_randomness();
    pushMatrix();
    stroke(255);
    noFill();
    colorMode(HSB, 200);
    float H = 0;
    translate(width/2,height/2);
    float A = 0;
    for (int i = 1; i<101; i = i + 1){
      R = K * sqrt(A);
      float X = R * cos(A);
      float Y = R * sin(A);
      if (do_colors) {
        float color_num = H % 200;
        //fill(color_num, 200,color_num,1);
        stroke(color_num,200,color_num);
      } else {
        //noFill();
        stroke(H,50);
      }
      H = H + C;
      ellipse(0,0,PApplet.parseInt(X),PApplet.parseInt(Y));
      //ellipse(int(X),int(Y),5,5);
      A = A + D;
    }
    popMatrix();
  }
  
  public void mouseDragged(){
    updateK(mouseX);
    updateC(mouseY); 
  }

  public void update(int num1, int num2) {
    updateK(num1);
    updateC(num2);
  }
  
  public void updateK(int num) {
    K = map(PApplet.parseFloat(num),0,127,10,200);
    println(" K = "+ K);
  }
  
  public void updateC(int num) {
    C = map(PApplet.parseFloat(num),0,127,1,20);
    D = TWO_PI/C;
    println(" C = "+C);
  }
  
  public void updateD(int num) {
    D = map(PApplet.parseFloat(num),0,1,2,500)/C;
  }
  
  public void update_do_colors(float num) {
    do_colors = PApplet.parseBoolean(PApplet.parseInt(num));
  }

  public void add_randomness(){
    if ((C == prevC) && (K == prevK) && (random(2)>1)){
      C = C + map(random(1), 0, 1, -(amount_of_randomness*20)/2, (amount_of_randomness*20)/2);
      K = K + map(random(1), 0, 1, -(amount_of_randomness*200)/2, (amount_of_randomness*200)/2);
      C = constrain(C, 1, 20);
      K = constrain(K, 10,200);
      amount_of_randomness = amount_of_randomness * (1+random(0.15f));
      amount_of_randomness = constrain(amount_of_randomness, 0, 1);
    } else {
      amount_of_randomness = .005f;
    }
    prevC = C;
    prevK = K;
  }
  
}
class gameOfLife extends patch {

  boolean[][] cells;
  int[][] neighbors;
  int[] size_of_cell = new int[2];
  int[] cells_size = {
    8, 8
  };
  int num_of_cells;
  private PApplet app;
  int evolve_every_n_renders;

  gameOfLife(PApplet app) {
    this.app = app;
    size_of_cell[0] = PApplet.parseInt(width/cells_size[0]);
    size_of_cell[1] = PApplet.parseInt(height/cells_size[1]);
    num_of_cells = cells_size[0] * cells_size[1]; 
    cells = new boolean[cells_size[0]][cells_size[1]];
    neighbors = new int[cells_size[0]][cells_size[1]];
    randomize(1);
    evolve_every_n_renders = 1;

    oscP5.plug(this, "randomize", "/4/toggle1");
    oscP5.plug(this, "glider", "/4/toggle2");
    oscP5.plug(this, "evolveEvery", "/4/evolveEvery");
  }

  public void render() {
    if (all_dead()) {
      randomize(1);
    }
    rectMode(CENTER);
    for (int i = 0; i< cells_size[0]; i++) {
      for (int j = 0; j < cells_size[1]; j++) {
        if (cells[i][j]) {
          fill(255);
        } 
        else {
          fill(0);
        }

        int xpos = i * size_of_cell[0];
        int ypos = j * size_of_cell[1];
        rect(xpos + (width*.03f), ypos, abs(i-cells_size[0]/2)*size_of_cell[0], abs(j-cells_size[1]/2)*size_of_cell[1]);
      }
    }

    // lets statistically approximate the speed for fun
    // should look a bit jittery, that's a lot of randomness
    if (PApplet.parseInt(random(evolve_every_n_renders)) == 1) {
      evolve();
    }
  }

  private boolean all_dead() {
    boolean all_dead = false;
    for (int i=0; i < cells_size[0]; i++) {
      for (int j=0; j < cells_size[1]; j++) {
        all_dead = all_dead | cells[i][j];
      }
    } 
    return all_dead;
  }

  private int num_of_neighbors(int i, int j) {
    int num = 0;
    int[][] neigh_pos = {
      //{-1,-1},
      {
        -1, 0
      }
      , 
      //{-1, 1},
      { 
        0, 1
      }
      , 
      { 
        0, -1
      }
      , 
      //{ 1, 1},
      { 
        1, 0
      }
      , 
      //{ 1,-1}
    };
    for (int k = 0; i < neighbors.length; i++) {
      int x_ind = (i + neigh_pos[k][0]);
      if (x_ind == -1) {
        x_ind = cells_size[0] - 1;
      }
      int y_ind = (j + neigh_pos[k][1]);
      if (y_ind == -1) {
        y_ind = cells_size[1] - 1;
      }

      if (cells[x_ind][y_ind]) {
        num++;
      }
    }

    return num;
  }

  public void evolve() {
    //update neighbors array
    for (int i = 0; i < cells_size[0]; i++) {
      for (int j = 0; j < cells_size[1]; j++) {
        neighbors[i][j] = num_of_neighbors(i, j);
      }
    }

    //apply rules of life
    for (int i = 0; i < cells_size[0]; i++) {
      for (int j = 0; j < cells_size[1]; j++) {
        if (neighbors[i][j] < 2) {
          cells[i][j] = false;
        } 
        else if (neighbors[i][j] > 3) {
          cells[i][j] = false;
        } 
        else if (neighbors[i][j] == 3) {
          cells[i][j] = true;
        }
      }
    }
  }

  public void randomize(float f) {
    for (int i = 0; i < cells_size[0]; i++) {
      for (int j = 0; j < cells_size[1]; j++) {
        cells[i][j] = random(1) < (f*.5f + .25f);
      }
    }
  }

  public void glider(float f) {
    for (int i= 0; i < cells_size[0]; i++) {
      for (int j=0; j < cells_size[1]; j++) {
        cells[i][j] = false;
      }
    }
    cells[PApplet.parseInt(cells_size[0]/2)][PApplet.parseInt(cells_size[1]/2)] = true;
  }

  public void delay(int delay) {
    int time = millis();
    while (millis () - time <= delay);
  }

  public void evolveEvery(int num_of_renders) {
    evolve_every_n_renders = num_of_renders;
  }
}

class patch {
  
 patch(){
   
 } 
 
 public void render(){
   
 }
  
}
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
    wave = new float[PApplet.parseInt(len)];
    waveColor = new float[PApplet.parseInt(len)];
    for (int i = 0; i < PApplet.parseInt(len); i++) {
      float amount = map(i, 0, PApplet.parseInt(len), 0, 2*TWO_PI);
      wave[i] = abs(cos(amount));
      waveColor[i] = 0;
    }
    oscP5.plug(this,"update_red","/1/fader1");
    oscP5.plug(this,"update_green","/1/fader2");
    oscP5.plug(this,"update_blue","/1/fader3");
    oscP5.plug(this,"update_deform","/1/fader5");
    oscP5.plug(this,"update_roundedness","/1/fader4");
  }
  
  public void render(){
    pushMatrix();
    colorMode(RGB,255);
    noFill();
    translate(IMG_WIDTH/2, IMG_HEIGHT/2);
    int stepSize = 3;
    for (int i = 0; i < PApplet.parseInt(len); i+=stepSize) {
      strokeWeight(stepSize);
      stroke(wave[i]*random(red_weight),wave[i]*random(green_weight),wave[i]*random(blue_weight));
      int x = (i+deform)%IMG_WIDTH;
      int y = (i-deform)%IMG_HEIGHT;
      if (drawShape == 'e'){
        ellipse(0, 0, x, y);
      } else if (drawShape == 'r'){
        box(x,y,PApplet.parseInt(x*y/2));
      }
    }
    shiftAndAdd(wave,wave[PApplet.parseInt(len)-1],10);
    popMatrix();
  }
  
  public void shiftAndAdd(float a[], float val, int numOfShifts){
    for (int i = 0; i < numOfShifts; i++) {
      int a_length = a.length;
      System.arraycopy(a, 0, a, 1, a_length-1);
      a[0] = val;
    }
  }
  
  public void update_red(float r) {
    red_weight = PApplet.parseInt(r*255);
  }
  
  public void update_green(float g) {
    green_weight = PApplet.parseInt(g*255);
  }
  
  public void update_blue(float b) {
    blue_weight = PApplet.parseInt(b*255);
  }
  
  public void update_deform(float d) {
    deform = PApplet.parseInt((d-.5f)*width*3);
  }
  
  public void update_roundedness(float d) {
    roundedness = PApplet.parseInt(d*.5f*displayHeight);
  }
 
}
class ripplingColors extends patch{
 
  float[] wave;
  float[] waveColor;
  float len;
//  int red_weight;
//  int green_weight;
//  int blue_weight;
  int deform; 
  char drawShape;
  int roundedness;
    
  ripplingColors(){
//    red_weight = 1;
//    green_weight = 1;
//    blue_weight = 1;
    deform = 0;
    drawShape = 'r';
    roundedness = 0;
    //colors setup
    len = sqrt(sq(height) + sq(width))/2;
    wave = new float[PApplet.parseInt(len)];
    waveColor = new float[PApplet.parseInt(len)];
    for (int i = 0; i < PApplet.parseInt(len); i++) {
      float amount = map(i, 0, PApplet.parseInt(len), 0, 2*TWO_PI);
      wave[i] = abs(cos(amount));
      waveColor[i] = 0;
    }
    oscP5.plug(this,"update_red_weight","/1/fader1");
    oscP5.plug(this,"update_green_weight","/1/fader2");
    oscP5.plug(this,"update_blue_weight","/1/fader3");
    oscP5.plug(this,"update_deform","/1/fader4");
    oscP5.plug(this,"update_roundedness","/1/fader5");

  }
  
  public void render(){
    pushMatrix();
    colorMode(RGB,255);
    noFill();
    translate(IMG_WIDTH/2, IMG_HEIGHT/2);
    int stepSize = 3;
    for (int i = 0; i < PApplet.parseInt(len); i+=stepSize) {
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
    shiftAndAdd(wave,wave[PApplet.parseInt(len)-1],10);
    popMatrix();
  }
  
  public void shiftAndAdd(float a[], float val, int numOfShifts){
    for (int i = 0; i < numOfShifts; i++) {
      int a_length = a.length;
      System.arraycopy(a, 0, a, 1, a_length-1);
      a[0] = val;
    }
  }
  
  //void update_red_weight(float f) {
  //  red_weight = f;
  //  println("red weight: " + str(red_weight));
  //}
  
  public void update_red_weight(int i) {
    red_weight = i*2;
    println("updating red weight to " + str(red_weight)); 
  }
  
  //void update_green_weight(float f) {
  //  green_weight = f;  
  //}
  
  public void update_green_weight(int i) {
    green_weight = i*2;
  }
  
  //void update_blue_weight(float f) {
  //  blue_weight = f;  
  //}
  //
  public void update_blue_weight(int i) {
    blue_weight = i*2;
  }
  
  public void update_deform(int d) {
    deform = PApplet.parseInt(map(d,0,127,-width, width));
  }
  
  public void update_roundedness(int d) {
    roundedness = PApplet.parseInt(map(d,0,127,0,.4f*displayHeight));
  }

}

}
