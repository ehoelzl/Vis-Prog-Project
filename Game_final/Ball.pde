class Ball{
  private float radius;
  private PVector location;
  private PVector nextLocation;
  private PVector gravityForce; //Kg*m/s²
  private PVector velocity; //mm/s
  private PVector nextVelocity;
  private PVector acceleration; // mm/s²
  private float normalForce = 0;
  private float mu = 0.25;
  private PVector friction;
  private float mass;
  private float elasticity = 0.6;
  
  Ball(float rad, float mass) { //Creates a ball with a given mass and radius
    this.mass = mass;
    radius = rad;
    nextLocation = new PVector(0, - .04*PLATE_DIM/2 - radius, 0);
    location = new PVector(0, - .04*PLATE_DIM/2 - radius,0);
    gravityForce = new PVector();
    
    velocity = new PVector(0,0,0);
    nextVelocity = new PVector(0,0,0);
    acceleration = new PVector(0,0,0);
    friction = new PVector(0,0,0);
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
  
  /*Updates the ball's location, and treats bounces*/
  void update(){
    nextVelocity = velocity.copy();
    computeVelocity(nextVelocity);
    computeLocation(nextLocation, nextVelocity);
    checkEdges(nextLocation, nextVelocity);
    cylinderCollision(nextLocation, nextVelocity);
    location = nextLocation.copy();
    velocity = nextVelocity.copy();
  }
  
  private void computeLocation(PVector loc, PVector vel){
    loc = loc.add(vel);
  }
  
  /*This function computes the Forces acting on the ball*/
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
    
    /*Computes the Velocity given the forces*/
     private void computeVelocity(PVector nextVelocity) {
      computeForces();
      acceleration = new PVector(gravityForce.x, 0, gravityForce.z);
      acceleration.add(friction).div(mass);
      acceleration.mult(deltaT*deltaT);
      nextVelocity.add(acceleration); 
    }
 
  
  
  /*Checks if the given location fits in the boundaries*/
  private void checkEdges(PVector loc, PVector vel) { 
    if(loc.x + radius > PLATE_DIM/2) {
      vel.x = (vel.x * -1)*elasticity;
      loc.x = PLATE_DIM/2 - radius;
    } else if (loc.x-radius < -PLATE_DIM/2) {
      vel.x = (vel.x * -1)*elasticity;
      loc.x = -PLATE_DIM/2 + radius;
    }
    
    if(loc.z + radius> PLATE_DIM/2) {
      vel.z = (vel.z * -1)*elasticity;
      loc.z = PLATE_DIM/2 - radius;
    } else if (loc.z - radius < -PLATE_DIM/2) {
      vel.z = (vel.z * -1)*elasticity;
      loc.z = -PLATE_DIM/2 + radius;
    }
     
  }
  
  /*Treats cylinder collisions given a certain location of ball and collision*/
  private void treatCollision(PVector location, PVector cyl, PVector vel){
    
      PVector n = location.copy().sub(cyl).normalize(); //Normal vector from cylinder to ball center 
      PVector newVelocity = vel.sub(n.copy().mult(2*vel.dot(n))); // New Velocity after collision 
      n.setMag(cylinderBaseSize + radius); // n points from cylinder center to 
      
      /*This resets the ball to the border of cylinder*/
      location.x = cyl.x + n.x;
      location.y = cyl.y;
      location.z = cyl.z + n.z;
     
      
      
      vel = newVelocity.mult(elasticity); //Set the velocity 
      
      /*Check if cylinder bounce throws the ball out of bounds*/
      checkEdges(location, vel);
    }
  
  
  /* Iterates on each cylinder and treats each collision seperately, changing the location of the ball accordingly*/
  private void cylinderCollision(PVector loc, PVector velocity){
    for(PVector v : cylinders){

      if (distance(loc.x, loc.z, v.x, v.y) <= cylinderBaseSize + radius) {
         treatCollision(loc, new PVector(v.x, loc.y, v.y), velocity);
      }
    }
  }
   
}