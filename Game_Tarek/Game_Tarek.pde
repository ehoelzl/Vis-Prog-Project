float radius = 17;
float ballMass = 10;



float rotateX = .0;
float rotateZ = .0;
float PLATE_DIM = 500;
float MAX_SPEED = 300;

float speedFactor = 64;
float GRAVITY = 9.81;

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
  translate(width / 2, height / 2, 0);
  camera(0,-250,700, 0,0,0,0,1,0);
  background(#403535);
  rotateX(rotateX);
  rotateZ(rotateZ);
  
  lights();
  ball.update();
  plate.display();
  ball.display();
}

void mouseDragged() {
    if(pmouseY > mouseY) { //rotateX
      rotateX = min(rotateX + PI / speedFactor, PI / 6);
    } else {
      if(pmouseY < mouseY) {
        rotateX = max(rotateX - PI / speedFactor, -PI / 6);
      }
    }
    
    if(pmouseX < mouseX) { //rotateZ
      rotateZ = min(rotateZ + PI / speedFactor, PI / 6);
    } else {
      if(pmouseX > mouseX) {
        rotateZ = max(rotateZ - PI / speedFactor, -PI / 6);
      }
    }
  }
  
  void mouseWheel(MouseEvent event) {
    speedFactor += event.getCount();
    speedFactor = max(50, speedFactor);
    speedFactor = min(speedFactor, MAX_SPEED);  }