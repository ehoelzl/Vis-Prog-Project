class Ball{
  float radius;
  PVector location;
  PVector nextLocation;
  PVector gravityForce; //Kg*m/s²
  PVector velocity; //mm/s
  PVector acceleration; // mm/s²
  float normalForce = 0;
  float mu = 0.1;
  PVector friction;
  float mass;
  float maxSpeed = 5;
  float elasticity = 0.4;
  
  Ball(float rad, float mass) { //Creates a ball with a given mass and radius
    this.mass = mass;
    radius = rad;
    nextLocation = new PVector(0, - .04*PLATE_DIM/2 - radius, 0);
    location = new PVector(0, - .04*PLATE_DIM/2 - radius,0);
    gravityForce = new PVector();
    
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
    computeVelocity();
    
    location.add(velocity);
    checkEdges();
    checkCylinders();
  }
  
  private void computeNextLocation(){
    location = nextLocation.copy();
    nextLocation = nextLocation.add(velocity);
  }
  
  /**
  * This function computes the Forces acting on the ball
  **/
    
    private void computeForces(){
      gravityForce.x = sin(rotateZ) * cos(rotateX) * GRAVITY;
      gravityForce.z = - sin(rotateX) * GRAVITY;
      gravityForce.y = cos(rotateX) * cos(rotateZ) * GRAVITY;
      gravityForce.mult(mass).mult(1000); // set gravity to Kg*mm/s² 
      
      normalForce = gravityForce.y;
      float mag = normalForce * mu;
      friction = velocity.copy();
      friction.mult(-1);
      friction.normalize();
      friction.mult(mag);
    }
    
     private void computeVelocity() {
      computeForces();
      acceleration = new PVector(gravityForce.x, 0, gravityForce.z);
      acceleration.add(friction).div(mass);
      acceleration.mult(deltaT*deltaT);
      velocity.add(acceleration); 
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
        
        PVector n = new PVector(location.x - v.x, location.z - v.y); //Vector from cylinder center to ball center
        n = n.normalize(); //normalized
        PVector V2 = velocity.sub(n.mult(2*velocity.dot(n)));
        velocity = V2.copy();
        velocity.y = 0;
      }
    }
  }
   
}