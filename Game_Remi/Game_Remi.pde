final static float scaleFactor = .04;
final static float MAX_SPEED = 300;
final static float gravityConstant = 9.81;
final static float normalForce = 1.0 * 1000;
final static float mu = .01;
final static float frictionMagnitude = normalForce * mu;
final static float plateWidth = 750 / 2f;
final static float sphereRadius = 20;

Ball ball;
Plate plate;
PVector gravityForce;
boolean shiftMode = false; 
float rotateX = .0;
float rotateZ = .0;
float speedFactor = 64;
float deltaT = 1 / frameRate;

void settings() {
  size(750, 750, P3D);
}

void setup() {
  noStroke();
  plate = new Plate();
  ball = new Ball();
  gravityForce = new PVector();
}


void draw() {  
  background(#403535);
  translate(width / 2f, height / 2f, 0);
  
  if(!shiftMode) {
    drawGame();
  } else {
    drawShiftMode();
  }
}

void drawGame() {
  perspective();
    camera(0, - height, plateWidth, 0, 0, 0, 0, 1, 0);

    rotateX(rotateX);
    rotateZ(rotateZ);
  
    gravityForce.x = sin(rotateZ) * gravityConstant * 1000;
    gravityForce.z = - sin(rotateX) * gravityConstant * 1000;

    plate.display();
  
    ball.update();
    ball.display();
}

void drawShiftMode() {
  ortho();
  camera(0, 0, 1.5 * plateWidth, 0, 0, 0, 0, 1, 0);
 
  rotateX(- PI / 2f);
  
  plate.display();
  ball.display();
  
}

void mouseDragged() {
  if(!shiftMode) {
    
    if(pmouseY > mouseY) { //rotateX
      rotateX = min(rotateX + PI / speedFactor, PI / 3);
    } else {
      if(pmouseY < mouseY) {
        rotateX = max(rotateX - PI / speedFactor, - PI / 3);
      }
    }
    
    if(pmouseX < mouseX) { //rotateZ
      rotateZ = min(rotateZ + PI / speedFactor, PI / 3);
    } else {
      if(pmouseX > mouseX) {
        rotateZ = max(rotateZ - PI / speedFactor, -PI / 3);
      }
    }
  }
}

void mousePressed() {
  if(shiftMode && plate.verifyBoundaries(mouseX - width / 2f, mouseY - height / 2f)) {
    plate.addCylinder();
  }
}

void mouseWheel(MouseEvent event) {
  if(!shiftMode) {
    
    speedFactor += event.getCount();
    speedFactor = max(50, speedFactor);
    speedFactor = min(speedFactor, MAX_SPEED);
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
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shiftMode = false;
    } 
  }
}