import netP5.*;
import oscP5.*;

import java.util.Map;

//import gifAnimation.*;
//import processing.opengl.*;

//import gab.opencv.*;
//import processing.video.*;
//import java.awt.*;

//Capture video;
//OpenCV opencv;

import processing.sound.*;
AudioIn in;

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
StringDict dev_patches;

HashMap<String, patch> patches;

//random color weights
float red_weight = .5;
float green_weight = .5;
float blue_weight = .5;

//video capture


//audio capture


//shaders
PShader frag_shader;

//GifMaker gifExport;

void setup(){
  //size(IMG_WIDTH,IMG_HEIGHT, P3D);
  //fullScreen(P3D);
  fullScreen();
  IMG_WIDTH = width;
  IMG_HEIGHT = height;
  
  oscP5 = new OscP5(this,12000);

  //load shaders
  frag_shader = loadShader("shader.glsl");
  
  //video = new Capture(this, 640, 480, cam_name);
  
  //video = new Capture(this, 1280, 960, cam_name);
  //opencv = new OpenCV(this, 640, 480);
  //video.start();
  
  //minim = new Minim(this);
  //in = minim.getLineIn(Minim.STEREO, 512);
    
  dev_patches = new StringDict();
  dev_timers = new IntDict();
  patches = new HashMap<String, patch>();
  
  patches.put("ripplingColors", new ripplingColors());
  patches.put("daisies", new daisies(this));
  patches.put("gameOfLife", new gameOfLife(this));
  //patches.add(new rippling3D());
  patches.put("circs", new FFTCircles(this));
  patches.put("circFlash", new circleFlasher(this));
  patches.put("streakfire", new streakfire(this));
  //patches.put("shader", new fragShaderPatch(frag_shader));
  //patches.add(new automata());
  //patches.add(new camBlobs(this));
  //patches.add(new MoveVol(this));
  //patches.add(new mesh());
  
  patches.get("circs").setIsActive(true);
  
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

  patches.forEach((k, v) -> v.render());

  //draw_connection_info();
  
  reset_patch_switch();
  for (String i : dev_patches.values()) {
    try {
      patches.get(i).setIsActive(true);
    } catch (Exception e) {
      println("Failed to load patch: " + i);
      println("Exception: ", e);
    }
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
  patches.forEach((k, v) -> v.setIsActive(false));
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
   String[] m = split(theOscMessage.addrPattern(), '/');
   println("m[1]: ", ((Object[])m)[1]);
   if (m.length == 3) {
     println("beep2");
     try {
        println("beep3");
        String patch_name = m[1];
          
        println( "Patch_name: " + patch_name);
        //device management
        if (patch_name=="exit"){
          dev_timers.remove(ip);
          dev_patches.remove(ip);
        } else {
          dev_patches.set(ip, patch_name);
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
  dev_timers.set(ip, millis());
}

void mouseDragged(){
  println("mouseX: " + mouseX);
  println("mouseY: " + mouseY);
  patches.forEach((k, v) -> v.mouseDragged());
}

/*boolean sketchFullScreen() {
  return true;
}*/

//public static void main(String[] args) { 
//  PApplet.main(new String[]{ "--hide-stop", viz.class.getName() });
//}

void keyPressed() {
  //println("stopping export");
  //gifExport.finish();
}
