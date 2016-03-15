void settings(){
  size(1000, 1000, P3D);
}

void setup(){
  noStroke();
}
float angle1 = 0;
float angle2 = 0;
float f = 1;
float speed = 0.02*f;

void mouseDragged(){
  if(mouseY - pmouseY > 0){
    if(angle1 <= PI/6-speed )
    angle1 = (angle1 + speed);
  }
  else if(mouseY - pmouseY < 0){
    if(angle1 >= -PI/6+speed){
      angle1 = (angle1 - speed);
    }
  }
  if(mouseX - pmouseX > 0){
    if(angle2 <= PI/6 - speed ){
      angle2 = (angle2 + speed);
    }
  }
  else if(mouseX - pmouseX < 0){
    if(angle2 >= -PI/6 + speed ){
      angle2 = (angle2 - speed);
    }
  }

}
float e = - 15;

void mouseWheel(MouseEvent event) {
  e = e + event.getCount()/4;
  if(e > 10){
    e=10;
    speed = 1*0.1;
  }
  else if(e < -30){
    e= -30;
    speed = 0.1/30; 
  }
  else if(e < 0){
    f = 1/(-e);
    speed = f*0.1;
  }
  else if (e > 0){
    f= e/10;
    speed = f*0.1;
  }
  else{
    speed =0.2;
  }
  println(e);
}

void draw(){
  background(40,40,40);
  translate(width/2, height/2, 0);
  directionalLight(50, 100, 125, 0, -1, 0);
  ambientLight(160, 50, 50);
  pushMatrix();
  rotateX(angle1);
  rotateZ(angle2);
  box(300, 8, 300);
  popMatrix();

}