float radius = 17;
float ballMass = 25;

boolean shiftMode = false;


float PLATE_DIM = 500;
float MAX_SPEED = 300;
float speedFactor = 64;
final float GRAVITY = 9.81;

Ball ball;
Plate plate;


void settings() {
  size(1000, 1000, P3D);
}

void setup() {
  ball = new Ball(radius, ballMass);
  plate = new Plate(PLATE_DIM);
}


void draw() { //Draws the game according to the mode
  background(#403535);
  translate(width / 2, height / 2, 0);
  if (shiftMode){
    drawShift();
  } else {
    pushMatrix();
    perspective();
    camera(0,-400, 1.5*plate.dims,0,0,0, 0,1,0); //place camera to be looking at plate from a certain distance
    ball.update();
    plate.display();
    ball.display();
    popMatrix();
  }
}

void drawShift(){ //Draws the Shift Mode of the game
  pushMatrix();
  ortho();
  camera(0, -1.5*plate.dims,0, 0, 0, 0, 0, 0, 1 ); //Place the camera above the plate
  plate.display();
  ball.display();
  popMatrix();
}

void keyPressed() { //Checks when to enter shiftMode
  if (key == CODED) {
    if (keyCode == SHIFT) {
    shiftMode = true;
    }
  }
}

void keyReleased() { //Checks when to exit shiftMode
  if (key == CODED){
    if (keyCode == SHIFT) {
    shiftMode = false;
    }
  }  
}

void mousePressed(){ 
  if(shiftMode){
    plate.mousePressed();
  }
}
void mouseDragged() {
  if(!shiftMode){
    plate.mouseDragged();
  }
  }
  
void mouseWheel(MouseEvent event) {
  plate.mouseWheel(event);    
}

 public double distance(float x1, float y1, float x2, float y2){ //Computes the distance between two points on the plane
   float distX = Math.abs(x1 - x2);
   float distY = Math.abs(y1 - y2);
   return Math.sqrt(distX*distX + distY*distY);
 }