import netP5.*;
import oscP5.*;

import oscP5.*;
import netP5.*;
//import gifAnimation.*;
//import processing.opengl.*;

//import gab.opencv.*;
//import processing.video.*;
//import java.awt.*;

//Capture video;
//OpenCV opencv;

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioInput in;
  
//String cam_name = "FaceTime HD Camera (Built-in)";
//String cam_name = "Vimicro USB2.0 PC Camera #6";
//String cam_name = "Sirius USB2.0 Camera #2";
//String cam_name = "USB 2.0 Camera #2";
//String cam_name = "HD USB Camera";

OscP5 oscP5;

// image dimensions
int IMG_WIDTH = 1280;
int IMG_HEIGHT = 720;
//final int IMG_WIDTH = 300;
//final int IMG_HEIGHT = 300;

//device management
IntDict dev_timers;
IntDict dev_patches;

ArrayList<patch> patches;
ArrayList<Boolean> patch_switch;

//random color weights
float red_weight = .5;
float green_weight = .5;
float blue_weight = .5;

//video capture


//audio capture


//shaders
PShader frag_shader_1;

//GifMaker gifExport;

void setup(){
  //size(IMG_WIDTH,IMG_HEIGHT, P3D);
  fullScreen(P3D);
  IMG_WIDTH = width;
  IMG_HEIGHT = height;
  oscP5 = new OscP5(this,12000);

  //video = new Capture(this, 640, 480, cam_name);
  
  //video = new Capture(this, 1280, 960, cam_name);
  //opencv = new OpenCV(this, 640, 480);
  //video.start();
  
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
    
  dev_patches = new IntDict();
  dev_timers = new IntDict();
  patches = new ArrayList<patch>();
  patch_switch = new ArrayList<Boolean>();
 
  //load shaders
  //frag_shader_1 = loadShader("noise.frag");
  
  patches.add(new ripplingColors());
  patches.add(new daisies(this));
  patches.add(new gameOfLife(this));
  patches.add(new rippling3D());
  patches.add(new FFTCircles(this));
  patches.add(new circleFlasher(this));
  patches.add(new streakfire(this));
  //patches.add(new fragShaderPatch(frag_shader_1));
  //patches.add(new automata());
  //patches.add(new camBlobs(this));
  //patches.add(new MoveVol(this));
  //patches.add(new mesh());
  
  
  int num_of_patches = patches.size();
  for (int i=0; i < num_of_patches; i++) {
    patch_switch.add(false);
  }
  //patch_switch.set(num_of_patches-2,true);
  patch_switch.set(num_of_patches-2, true);
  
  oscP5.plug(this,"pinged","/ping");
//  oscP5.plug(this,"update_red_weight","/1/fader1");
//  oscP5.plug(this,"update_green_weight","/1/fader2");
//  oscP5.plug(this,"update_blue_weight","/1/fader3");

  //gifExport = new GifMaker(this, "export.gif");
  //gifExport.setRepeat(0); // make it an "endless" animation
  //gifExport.setTransparent(0,0,0); // make black the transparent color. every black pixel in the animation will be transparent
  
  noCursor();
}

void draw(){
  timeout_check();
  //background(0);
//  red_weight = int(random(255));
//  green_weight = int(random(255));
//  blue_weight = int(random(255));
  //draw_connection_info();

  for (int i=0; i<patches.size(); i++){
   if (patch_switch.get(i)){
     //println("i'm here");
     //println(patch_switch);
     patch p = patches.get(i);
     p.render(); 
   }
  }

  //draw_connection_info();
  
  reset_patch_switch();
  for (int i : dev_patches.values()) {
    patch_switch.set((i), true);
  }
 
  //gifExport.setDelay(1);
  //gifExport.addFrame(); 
}

void draw_connection_info(){
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

void reset_patch_switch() {
  for (int i=0; i < patch_switch.size(); i++) {
    patch_switch.set(i,false);
  } 
}
void pick_single_patch(ArrayList<Boolean> patch_swtich, int num){
  for (int i=0; i < patch_switch.size(); i++) {
    if (i==num) {
      patch_switch.set(i,true);
    } else {
      patch_swtich.set(i,false);
    }
  }
}
/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* with theOscMessage.isPlugged() you check if the osc message has already been
   * forwarded to a plugged method. if theOscMessage.isPlugged()==true, it has already 
   * been forwared to another method in your sketch. theOscMessage.isPlugged() can 
   * be used for double posting but is not required.
  */
 println("addrPattern: " + theOscMessage.addrPattern());
         println("### received an osc message.");
        println("### addrpattern\t"+theOscMessage.addrPattern());
        println("### typetag\t"+theOscMessage.typetag());
        println("### netaddress"+theOscMessage.netAddress());
        println("### .get(0)"+theOscMessage.get(0));

 String ip = theOscMessage.get(0).stringValue();
 // dev_timers.set(ip, millis());
 println("IP: " + ip);
 println("beep0");
 println(theOscMessage.isPlugged());
if(theOscMessage.isPlugged()==false) {
   println("beep1");
   println(theOscMessage.addrPattern());
   String[] m = match(theOscMessage.addrPattern(), "/[0-9]*/");
   println(m);
   if (m.length == 1) {
     println("beep2");
     try {
        println("beep3");
        int patch_num = int(str(theOscMessage.addrPattern().charAt(1)));
          
        println( "Patch_num: " + str(patch_num));
        //device management
        if (patch_num==9){
          dev_timers.remove(ip);
          dev_patches.remove(ip);
        } else {
          dev_patches.set(ip, patch_num);
          dev_timers.set(ip, millis());
        }
      
      } catch (Exception e) {
        println("error parsing patch code");
      }
      
      println("### received an osc message.");
      println("### addrpattern\t"+theOscMessage.addrPattern());
      println("### typetag\t"+theOscMessage.typetag());
      println("### netaddress"+theOscMessage.netAddress());
   
   } else {
        /* print the address pattern and the typetag of the received OscMessage */
        println("### received an osc message.");
        println("### addrpattern\t"+theOscMessage.addrPattern());
        println("### typetag\t"+theOscMessage.typetag());
        println("### netaddress"+theOscMessage.netAddress());
   }
 }

}

void timeout_check(){
  if (dev_patches.size()>2){
    for (String ip : dev_timers.keys()){
      if ((millis()-dev_timers.get(ip))>3e5){
        dev_timers.remove(ip);
        dev_patches.remove(ip);
        println(ip + " timedout");
      }
    }
  }
}

void pinged(String ip){
  dev_timers.set(ip,millis());
}

void mouseDragged(){
  println("mouseX: " + mouseX);
  println("mouseY: " + mouseY);
  for (int i=0; i<patch_switch.size(); i++){
    if (patch_switch.get(i)){
      patches.get(i).mouseDragged();
    }
  }
}

/*boolean sketchFullScreen() {
  return true;
}*/

public static void main(String[] args) { 
  PApplet.main(new String[]{ "--hide-stop", viz.class.getName() });
}

void keyPressed() {
  //println("stopping export");
  //gifExport.finish();
}
