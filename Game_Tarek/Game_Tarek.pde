float radius = 17;
float ballMass =25;

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


void draw() {
  background(#403535);
  translate(width / 2, height / 2, 0);
  if (shiftMode){
    plate.display_shift();
    ball.display2D();
  } else {
    translate(0, 150, 0);
    ball.update();
    plate.display_game();
    ball.display();
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
    shiftMode = true;
    }
  }
}

void keyReleased() {
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