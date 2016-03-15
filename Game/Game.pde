float rotateX = .0;
float rotateZ = .0;
float scaleFactor = .04;
float speedFactor = 64;
float MAX_SPEED = 300;
float gravityConstant = 9.8;
float normalForce = 1.0;
float mu = .01;
float frictionMagnitude = normalForce * mu;
float plateWidth = 750 / 2f;
Ball ball;
Plate plate;
PVector gravityForce;

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
  translate(width / 2, height / 2, 0);
  background(#403535);
  
  rotateX(rotateX);
  rotateZ(rotateZ);
  
  gravityForce.x = sin(rotateZ) * gravityConstant;
  gravityForce.z = sin(rotateX) * gravityConstant;

  plate.display();
  
  ball.update();
  ball.display();

}

void mouseDragged() {
  if(pmouseY > mouseY) { //rotateX
    rotateX = min(rotateX + PI / speedFactor, PI / 3);
  } else {
    if(pmouseY < mouseY) {
      rotateX = max(rotateX - PI / speedFactor, -PI / 3);
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

void mouseWheel(MouseEvent event) {
  speedFactor += event.getCount();
  speedFactor = max(50, speedFactor);
  speedFactor = min(speedFactor, MAX_SPEED);
  println(event.getCount());
  println(speedFactor);
}