class caliSunset extends patch{
 PImage img;

 caliSunset(){
  img = loadImage("california_sunset.jpg");
 } 
 
 void render(){
  imageMode(CORNER);
  colorMode(RGB,100);
  tint(red_weight*100,green_weight*100,blue_weight*100);
  image(img, 0, 0, width, height); 
 }
 
}
