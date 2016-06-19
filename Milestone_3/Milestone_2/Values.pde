class Crotte{

 HScrollbar lowerhue ;
   HScrollbar upperhue ;
   HScrollbar lowerbrightness;
HScrollbar upperbrightness;
 HScrollbar uppersaturation;
HScrollbar lowersaturation;
  
  Crotte(){
    lowerhue = new HScrollbar(0,originalHeight+ 20,255,15);
    upperhue = new HScrollbar(0,originalHeight+ 60,255,15);
    lowerbrightness = new HScrollbar(0,originalHeight+  100,255,15);
    upperbrightness =  new HScrollbar(0,originalHeight+ 140,255,15);
    lowersaturation = new HScrollbar(0,originalHeight+ 180,255,15);
    uppersaturation = new HScrollbar(0,originalHeight+ 220,255,15);
  } 
  public void drawScrollbars() {
    //background(255);
    lowerhue.update();
    lowerbrightness.update();
    lowersaturation.update();
    upperhue.update();
    upperbrightness.update();
    uppersaturation.update();
    
    lowerhue.display();
    lowerbrightness.display();
    lowersaturation.display();
    upperhue.display();
    upperbrightness.display();
    uppersaturation.display();  
  }
}