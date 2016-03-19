float rotateX = .0;
float rotateZ = .0;
float scaleFactor = .04;
float speedFactor = 64;
float MAX_SPEED = 300;
float gravityConstant = 9.81;
float normalForce = 1.0 * 1000;
float mu = .01;
float frictionMagnitude = normalForce * mu;
float plateWidth = 750 / 2f;
Ball ball;
Plate plate;
PVector gravityForce;
float deltaT = 1 /30f;

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
  camera(width / 2f, - height, (height/2.0) / tan(PI*60 / 180.0), width/2.0, height / 2f, 0., 0., 1., 0.);
  translate(width / 2f, height / 2f, 0);
  background(#403535);
  
  rotateX(rotateX);
  rotateZ(rotateZ);
  
  gravityForce.x = sin(rotateZ) * gravityConstant * 1000;
  gravityForce.z = sin(rotateX) * gravityConstant * 1000;

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