import processing.sound.*;

class FFTCircles extends patch{
  
  FFT fft;
  AudioIn in;
  float[] spectrum;
  String windowName;
  private PApplet app;
  int opacity = 30;
  float stroke_factor = 2;
  int circle_thickness = 10;
  int sample_rate;
  
  FFTCircles(PApplet app){
    this.app = app;
    sample_rate = 512;
    //sound setup
    fft = new FFT(app, sample_rate);
    in = new AudioIn(app, 0);
    in.start();
    fft.input(in);
    
    spectrum = new float[sample_rate];
    windowName = "None";
    oscP5.plug(this,"update","/circs/xy");
  }
  
  void _render(){
    pushStyle();
    colorMode(RGB, 255);
    stroke(random(red_weight),random(green_weight),random(blue_weight), opacity);
    strokeWeight(stroke_factor*this.circle_thickness);
    noFill();
    // perform a forward FFT on the samples in jingle's left buffer
    // note that if jingle were a MONO file, 
    // this would be the same as using jingle.right or jingle.left
    fft.analyze(spectrum);
    for(int i = 0; i < sample_rate; i++)
    {
      // draw the line for frequency band i, scaling it by 4 so we can see it a bit better
      float current_stroke = spectrum[i]*250;
      if (current_stroke > 50){
        stroke(random(current_stroke*red_weight)/10,random(current_stroke*green_weight)/10,random(current_stroke*blue_weight)/10, 30);
        ellipse(int(width/2), int(height/2),i*this.circle_thickness,i*this.circle_thickness);
      }
    }
    popStyle();
  }
  
  void update(int x, int y) {
    opacity = int(map(x, 0, 127, 1, 200));
    stroke_factor = map(y, 0, 127, 0.2, 20);
    //circle_thickness = int(map(y, 0, 127, 1, width));
  }
  
}
