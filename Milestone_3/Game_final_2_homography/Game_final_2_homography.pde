protected float radius = 12;
protected float ballMass = 10;
final float PLATE_DIM = 500;
final float GRAVITY = 9.81;
final float MAX_SPEED = 300;
final float deltaT = 1/60f;
protected Ball ball;
protected Plate plate;
protected Panel panel;
Image_Processing imgproc;
PVector angles;
float speedFactor = 64;
boolean shiftMode = false;

boolean vrMode = true;



void settings() {
    size(1000, 1000, P3D);
  
}

PImage bg;
void setup() {

   if (vrMode){
     imgproc = new Image_Processing();
     String[] args ={"Image processing window"};
     PApplet.runSketch(args, imgproc);
  }
  
  
  
  ball = new Ball(radius, ballMass);
  plate = new Plate(PLATE_DIM);
  panel = new Panel();
}


/**
* Draws the game according to the mode
*/
void draw() {
  if (vrMode){
    angles = imgproc.getAngles();
    plate.changeAngles(angles.x, angles.y);
  }
  
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

PImage flip(PImage image) {
  PImage newIm = new PImage(image.width, image.height);
  for (int i = 0; i < image.width; i ++){
    for (int j = 0; j < image.height; j++){
      newIm.set(image.width - 1 - i, j, image.get(i,j));
    }
  }
  return newIm;
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
* If we are not in shiftMode, when the mouse is dragged we call the plate function that permits to tilt the plate
*/
void mouseDragged() {
  if(!shiftMode && !vrMode){
    plate.mouseDragged();
  }
}
/**
* Helper function to calculate the distance between two 2D points
*/
protected double distance(float x1, float y1, float x2, float y2) {
   float distX = Math.abs(x1 - x2);
   float distY = Math.abs(y1 - y2);
   return Math.sqrt(distX * distX + distY * distY);
 }