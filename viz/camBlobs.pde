//class camBlobs extends patch {
 
//  private PApplet app;
//  PImage cur, prev;
//  int X, Y, thresh, opac;
  
//  camBlobs(PApplet app){
//    prev = opencv.getSnapshot();
//    oscP5.plug(this,"update","/6/xy");
//    X = 125;
//    Y = 125; 
//    thresh = 100; 
//    opac = 125; 
//    //println(Capture.list());
//  }
  
//  void render(){
//    pushStyle();
//    opencv.loadImage(video);
//    cur = opencv.getSnapshot();
//    opencv.diff(prev);
//    //opencv.findSobelEdges(1,2);
//    opencv.brightness((X/50)+25);
//    opencv.contrast((Y/1000.) + 1);
//    //opencv.findCannyEdges(X,Y);
//    opencv.dilate();
//    opencv.dilate();
//    //opencv.loadImage(video);
//    imageMode(CENTER);
//    opencv.threshold(thresh);
//    tint(255, opac);
//    opencv.flip(1);
//    image(opencv.getSnapshot(), 0,0, width*2, height*2);
//    //image(opencv.getSnapshot(), 0,0, width, height);
//    prev = cur;
//    popStyle();
//  }
  
//  void update(int x, int y){
//    println("updating camblobs");
//    println(x);
//    println(y);
//    thresh = int(map(y, 0, 127, 10, 255));
//    opac = int(map(x, 0, 127, 10, 255));
//  }
  
//  void mouseDragged(){
//    X = mouseX;
//    Y = mouseY;
//  }
//}
