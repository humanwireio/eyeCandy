
class daisies extends patch{
  //Diasies From Mathographics book by Robert Dixon pg 131
  float K = 5;
  float C = 360/222.49;
  float D = TWO_PI/C;
  //float D = 74/C;
  float R;
  float RR = 5;
  private PApplet app;
  boolean do_colors = false;
  
  daisies(PApplet app){
    this.app = app;
    //fill(255);
    //oscP5.plug(this,"updateK","/1/fader1");
    //oscP5.plug(this,"updateC","/1/fader2");
    oscP5.plug(this,"update","/3/xy");
    oscP5.plug(this,"update_do_colors","/3/toggle1");
    oscP5.plug(this,"updateD","/1/fader1");
  }

  void render() {
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
      ellipse(0,0,int(X),int(Y));
      //ellipse(int(X),int(Y),5,5);
      A = A + D;
    }
    popMatrix();
  }
  
  void mouseDragged(){
    updateK(mouseX);
    updateC(mouseY); 
  }

  void update(int num1, int num2) {
    updateK(num1);
    updateC(num2);
  }
  
  void updateK(int num) {
    K = map(float(num),0,127,10,200);
    println(" K = "+ K);
  }
  
  void updateC(int num) {
    C = map(float(num),0,127,1,20);
    D = TWO_PI/C;
    println(" C = "+C);
  }
  
  void updateD(int num) {
    D = map(float(num),0,1,2,500)/C;
  }
  
  void update_do_colors(float num) {
    do_colors = boolean(int(num));
  }
}
