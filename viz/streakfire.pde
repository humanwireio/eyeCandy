class streakfire extends patch{
  int offset_max = 400;
  int stroke_thickness = 4;
  private PApplet app;
  
  streakfire(PApplet app){
    this.app = app;
    oscP5.plug(this,"update","/6/xy");
  }
  
  void render(){
    int offset_x = 0;
    int offset_y = 0;
    pushMatrix();
    translate(width/2, height/2);
    rotate(random(TWO_PI));
    for (int i=0; i< 200; i++){
      offset_x = int(offset_x + random(this.offset_max)) % width;
      offset_y = int(offset_y + random(this.offset_max)) % height;
      pushMatrix();
      pushStyle();
      stroke(255);
      strokeWeight(stroke_thickness);
      translate(offset_x, offset_y);
      line(0, 0, random(this.offset_max), random(this.offset_max));
      popStyle();
      popMatrix();
    }
    popMatrix();
  }
  
  void update(int x, int y) {
    offset_max = int(map(x, 0, 127, 1, width));
    stroke_thickness = int(map(y, 0, 127, 1, 20));
  }
}
