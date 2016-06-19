
PVector newAngles;
class Image_Processing extends PApplet{
   Movie cam = new Movie(this, "testvideo.mp4");
   
   void settings(){
     
     size(540, 370, P3D);
   }
   void setup(){
     newAngles = new PVector(0,0,0);
     //cam = new Movie(this, "/Users/lucasgauchoux/Documents/Processing/Game_final_2_homography/data/testvideo.mp4");
     //cam.get();
     /*String[] cameras = Capture.list();
  if(cameras.length == 0) {
  println("There are no cameras available for capture.");
  exit();
  } else {
   println("Available cameras:");
  for (int i = 0; i < cameras.length; i++) {
     println(cameras[i]);
  }
  //new Capture(this, 640, 480);
  //cam.start();
  cam.loop();
   
   }*/
	cam.loop();
 }
   void draw(){
   
   if(cam.available()){
     cam.read();
   }
   image(cam, 0, 0);
   }
   PVector getAngles(){
     if(cam.available()){
   
       newAngles = getBoardAngles(cam.get());
     }
     return newAngles;
   }
}