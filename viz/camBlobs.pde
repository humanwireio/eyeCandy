/**
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

class camBlobs extends patch {
 
  private PApplet app;
  Capture video;
  OpenCV opencv;
  PImage cur, prev;
  int X, Y;
  
  camBlobs(PApplet app){
    String[] cameras = Capture.list();
    String cam_name = "Sirius USB2.0 Camera #3";
    println(str(cameras.length) + " cameras found"); 
    this.app = app;
    video = new Capture(this.app, 640, 480, cam_name);
    opencv = new OpenCV(this.app, 640, 480);
    //opencv.startBackgroundSubtraction(5, 3, 0.5);
    video.start();
    prev = opencv.getSnapshot();
    oscP5.plug(this,"update","/8/xy");
    X = int(random(255));
    Y = int(random(255)); 
    //println(Capture.list());
  }
  
  void render(){
    opencv.loadImage(video);
    cur = opencv.getSnapshot();
    opencv.diff(prev);
    //opencv.findSobelEdges(1,2);
    opencv.brightness((X/50)+25);
    opencv.contrast((Y/1000.) + 1);
    //opencv.findCannyEdges(X,Y);
    opencv.dilate();
    opencv.dilate();
    //opencv.loadImage(video);
    imageMode(CENTER);
    tint(255,125);
    image(opencv.getSnapshot(), 0,0, width*2, height*2 );
    prev = cur;
  }
  
  void update(int x, int y){
    X = x;
    Y = y;    
  }
  
  void mouseDragged(){
    X = mouseX;
    Y = mouseY;
  }
}
**/
