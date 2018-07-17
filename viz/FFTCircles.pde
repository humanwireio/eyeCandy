import ddf.minim.analysis.*;
import ddf.minim.*;

class FFTCircles extends patch{
  
  Minim minim;
  AudioInput in;
  FFT fft;
  String windowName;
  private PApplet app;
  int opacity = 30;
  float stroke_factor = 2;
  
  FFTCircles(PApplet app){
    this.app = app;
    //sound setup
    minim = new Minim(app);
    in = minim.getLineIn(Minim.STEREO, 512);
    fft = new FFT(in.bufferSize(), in.sampleRate());
    windowName = "None";
    oscP5.plug(this,"update","/4/xy");
  }
  
  void render(){
    pushStyle();
    colorMode(RGB, 255);
    stroke(random(red_weight),random(green_weight),random(blue_weight), opacity);
    int CircleThickness = 4;
    strokeWeight(stroke_factor*CircleThickness);
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
        ellipse(int(width/2), int(height/2),i*CircleThickness,i*CircleThickness);
      }
    }
    popStyle();
  }
  
  void update(int x, int y) {
    opacity = int(map(x, 0, 127, 1, 200));
    stroke_factor = map(y, 0, 127, 0.2, 20);
  }
  
}
