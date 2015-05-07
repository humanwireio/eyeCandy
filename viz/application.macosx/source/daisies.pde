
class daisies extends patch{
  //Diasies From Mathographics book by Robert Dixon pg 131
  float K = 5;
  float C = 360/222.49;
  float prevK = 5;
  float prevC = 360/222.49;
  float D = TWO_PI/C;
  //float D = 74/C;
  float R;
  float RR = 5;
  private PApplet app;
  boolean do_colors = false;
  float amount_of_randomness = .005;
  
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

  void add_randomness(){
    if ((C == prevC) && (K == prevK) && (random(2)>1)){
      C = C + map(random(1), 0, 1, -(amount_of_randomness*20)/2, (amount_of_randomness*20)/2);
      K = K + map(random(1), 0, 1, -(amount_of_randomness*200)/2, (amount_of_randomness*200)/2);
      C = constrain(C, 1, 20);
      K = constrain(K, 10,200);
      amount_of_randomness = amount_of_randomness * (1+random(0.15));
      amount_of_randomness = constrain(amount_of_randomness, 0, 1);
    } else {
      amount_of_randomness = .005;
    }
    prevC = C;
    prevK = K;
  }
  
}
