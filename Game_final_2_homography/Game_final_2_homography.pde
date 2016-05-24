protected float radius = 12;
protected float ballMass = 10;
final float PLATE_DIM = 500;
final float GRAVITY = 9.81;
final float MAX_SPEED = 300;
final float deltaT = 1/60f;
protected Ball ball;
protected Plate plate;
protected Panel panel;

float speedFactor = 64;
boolean shiftMode = false;

PImage original;

Capture cam;


void settings() {
   //original = loadImage("board4.jpg");
   bg = loadImage("background2.jpg");
    size(1000, 1000, P3D);
  
}

PImage bg;
void setup() {
  /*pushMatrix();
   background(bg);
   popMatrix();*/
  String[] cameras = Capture.list();
  if(cameras.length == 0) {
  println("There are no cameras available for capture.");
  exit();
  } else {
   println("Available cameras:");
  for (int i = 0; i < cameras.length; i++) {
     println(cameras[i]);
  }
  cam = new Capture(this, 640, 480);
  cam.start();
  }
  
  ball = new Ball(radius, ballMass);
  plate = new Plate(PLATE_DIM);
  panel = new Panel();
}


/**
* Draws the game according to the mode
*/
void draw() {
  
  if(cam.available() == true) {
    cam.read();
  }
  original = cam.get();
  
  PVector angles = getBoardAngles(original);
  plate.changeAngles(angles.x, angles.z);
  print(angles.toString());
  background(#7996E3);
  directionalLight(255,255,255,0, 2,-15);
  panel.drawPanel(ball);
  pushMatrix();
  translate(width / 2, height / 2, 0); // Set the origin to the center 
 
  if (shiftMode){
    drawShift(); 
  } else {
    pushMatrix();
    perspective();
    
    camera(0, -600,  1.3*plate.dim, 0, 0, 0, 0, 1, 0); //place camera to be looking at plate from a certain distance
    ball.update(panel); // updates the ball's position for this frame
    plate.display(); // displays the plate
    ball.display(); // displays the ball
    
    popMatrix();
  }
  popMatrix();
}

/**
* Draws the plate with a top down view, the game is paused and permits to add cylinders on the plate
*/
void drawShift() { 
  pushMatrix();
  ortho();
  
  camera(0, -1.5 * plate.dim, 0, 0, 0, 0, 0, 0, 1); //Places the camera above the plate
  plate.display(); // displays the plate
  ball.display(); // displays the ball
  
  popMatrix();
}

/**
* Checks whenever we enter the shiftMode by pressing the shift key
*/
void keyPressed() {   
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shiftMode = true;
    }
  }
}

/**
* Checks whenever we get out of the shiftMode by releasing the shift key
*/
void keyReleased() { 
  if (key == CODED){
    if (keyCode == SHIFT) {
      shiftMode = false;
    }
  }  
}

/**
* Whenever the mouse is pressed we call the mousePressed function of Plate to add cylinders
*/
void mousePressed() { 
  if(shiftMode){
    plate.mousePressed();
  }
}

/**
* If we are not in shiftMode, when the mouse is dragged we call the plate function that permits to tilt the plate
*/
/*void mouseDragged() {
  if(!shiftMode && mouseY < 800){
    plate.mouseDragged();
  }
}*/

/**
* On a wheel event we call the plate function that permits to adjust the tilting speed
*/
void mouseWheel(MouseEvent event) {
  plate.mouseWheel(event);    
}

/**
* Helper function to calculate the distance between two 2D points
*/
protected double distance(float x1, float y1, float x2, float y2) {
   float distX = Math.abs(x1 - x2);
   float distY = Math.abs(y1 - y2);
   return Math.sqrt(distX * distX + distY * distY);
 }