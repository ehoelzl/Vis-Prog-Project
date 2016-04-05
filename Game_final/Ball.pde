class Ball{
  private float radius;
  private PVector location;
  private PVector nextLocation;
  private PVector gravityForce; //Kg*m/s²
  private PVector velocity; //mm/s
  private PVector acceleration; // mm/s²
  private float normalForce = 0;
  private float mu = 0.25;
  private PVector friction;
  private float mass;
  private float maxSpeed = 5;
  private float elasticity = 0.4;
  
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
  
  /*Updates the ball's location, and treats bounces*/
  void update(){
    computeVelocity();
    computeLocation(nextLocation);
    cylinderCollision(nextLocation);
    checkEdges(nextLocation);
    location = nextLocation.copy();
  }
  
  private void computeLocation(PVector loc){
    loc = loc.add(velocity);
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
     private void computeVelocity() {
      computeForces();
      acceleration = new PVector(gravityForce.x, 0, gravityForce.z);
      acceleration.add(friction).div(mass);
      acceleration.mult(deltaT*deltaT);
      velocity.add(acceleration); 
    }
 
  
  
  /*Checks if the given location fits in the boundaries*/
  private void checkEdges(PVector location) { 
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
    } else if (nextLocation.z - radius < -PLATE_DIM/2) {
      velocity.z = (velocity.z * -1)*elasticity;
      location.z = -PLATE_DIM/2 + radius;
    }
     
  }
  
  /*Treats cylinder collisions given a certain location of ball and collision*/
  private void treatCollision(PVector ball, PVector cyl){
    
      PVector n = ball.sub(cyl).normalize(); //Normal vector from cylinder to ball center 
      PVector newVelocity = velocity.sub(n.copy().mult(2*velocity.dot(n))); // New Velocity after collision 
      n.setMag(cylinderBaseSize + radius); // n points from cylinder center to 
      
      /*This resets the ball to the border of cylinder*/
      ball.x = cyl.x + n.x;
      ball.y = cyl.y;
      ball.z = cyl.z + n.z;
      
      
      velocity = newVelocity.copy().mult(elasticity); //Set the velocity 
      
      /*Check if cylinder bounce throws the ball out of bounds*/
      computeLocation(ball);
      checkEdges(ball);
    }
  
  
  /* Iterates on each cylinder and treats each collision seperately, changing the location of the ball accordingly*/
  private void cylinderCollision(PVector loc){
    for(PVector v : cylinders){

      if (distance(loc.x, loc.z, v.x, v.y) <= cylinderBaseSize + radius) {
         treatCollision(loc, new PVector(v.x, loc.y, v.y));
      }
    }
  }
   
}