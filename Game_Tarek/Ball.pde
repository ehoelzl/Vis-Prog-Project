class Ball{
  float radius;
  PVector location;
  PVector velocity;
  PVector acceleration;
  float normalForce = 1;
  float mu = 0.01;
  PVector friction;
  float mass;
  float maxSpeed = 5;
  float elasticity = 0.4;
  
  Ball(float rad, float mass) { //Creates a ball with a given mass and radius
    this.mass = mass;
    radius = rad;
    location = new PVector(0, - .04*PLATE_DIM/2 - radius, 0);
    velocity = new PVector(0,0,0);
    acceleration = new PVector(0,0,0);
    friction = new PVector(0,0,0);
    velocity.limit(maxSpeed);
  }
  
  void display() { //Display the ball on given coordinates
    pushMatrix();
    noStroke();
    lights();
    fill(#F5A800);
    translate(location.x, location.y, location.z);
    sphere(radius);
    popMatrix();
  }
  
  void update(){ //Updates the ball's location according to gravity and friction
    float mag = normalForce*mu;
    friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(mag);
    
    acceleration.x = (sin(rotateZ) * GRAVITY + friction.x)/mass;
    acceleration.z = (-(sin(rotateX) * GRAVITY) + friction.z)/mass;
    
    velocity = velocity.add(acceleration); //we update the velocity at every frame
    
    
    location = location.add(velocity);
    checkEdges();
    checkCylinders();
  }
  
  private void checkEdges() { //Checks the edges of the ball and changes the position and the velocity accordingly
    if(location.x + radius > PLATE_DIM/2) {
      velocity.x = (velocity.x * -1)*elasticity;
      location.x = PLATE_DIM/2 - radius;
    } else if (location.x-radius < -PLATE_DIM/2) {
      velocity.x = (velocity.x * -1)*elasticity;
      location.x = -PLATE_DIM/2 + radius;
    }
    
    if(location.z + radius> PLATE_DIM/2) {
      velocity.z = (velocity.z * -1)*elasticity;
      location.z = PLATE_DIM/2 - radius;
    } else if (location.z - radius < -PLATE_DIM/2) {
      velocity.z = (velocity.z * -1)*elasticity;
      location.z = -PLATE_DIM/2 + radius;
    }
     
  }
  
  private void checkCylinders(){
    for(PVector v : cylinders){

      if (distance(location.x, location.z, v.x, v.y) <= cylinderBaseSize + radius) {
        
        PVector n = new PVector(location.x - v.x, location.y, v.y); //Vector from cylinder center to ball center
        n = n.normalize(); //normalized
        PVector V2 = velocity.sub(n.mult(2*velocity.dot(n)));
        velocity = V2.copy();
        velocity.y = 0;
      }
    }
  }
   
}