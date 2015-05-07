class circleFlasher extends patch {
    
   private PApplet app;
   int drawX, drawY, delX, delY;
   int curX, curY, prevX, prevY;
   
   circleFlasher(PApplet app){
     this.app = app;
     drawX = width/2;
     drawY = height/2;
     delX = 0;
     delY = 0;
     curX = 0;
     curY = 0;
     prevX = 0;
     prevY = 0;
     oscP5.plug(this,"update","/7/xy");
   }
   
   void render(){
    pushMatrix();
    //translate(width/2, height/2);
    //background(random(255),random(255),random(255),random((delX^2 + delY^2)));
    for (int i=50; i>0; i--){
      drawX = (drawX + delX)%width;
      drawY = (drawY + delY)%height;
      //fill(random(255), random(255), random(255), random(25));
      fill(random(255), random(255), random(255), random(5));
      ellipse(drawX, drawY, 50*i,50*i);
      //rect(drawX, drawY, 50*i,50*i);
    }
    popMatrix();   
   }
   
    void update(int x, int y) {
      prevX = curX;
      curX = x;
      prevY = curY;
      curY = y;
      delX = curX-prevX;
      delY = prevY-curY;
      println("delX: " + delX);
      println("delY: " + delY);
    }
    
    void mouseDragged(){
      delX = mouseX-pmouseX;
      delY = mouseY-pmouseY;
    }
}
