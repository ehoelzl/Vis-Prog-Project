color ballColor = #000EFC;
/**
* The class Ball permits to handle all of the ball's functionalities
*/
class Ball {
  
  private float radius; // [mm]
  private float sphereY; // The y position of the ball, permits to the ball to be on top of the plate
  public PVector location;
  private PVector nextLocation;
  private PVector gravityForce;  //[Kg * mm / s² ]
  private PVector velocity; //[mm/s]
  private PVector nextVelocity; //[mm/s]
  private float normalForce = 0;
  private float mu = 0.25;
  private PVector friction;
  private float mass;
  private float elasticity = 0.6; // each bounce on a cylinder/boudary absorbs ((1 - 'elasticity') * 100) % of the force 
  
  
  PVector potentialVelocity = new PVector();
  /**
  * The constructor of the class Ball, initializes the pertinent variables, given a radius and a mass
  */
  Ball(float rad, float mass) { 
    this.mass = mass;
    radius = rad;
    sphereY = - .04 * PLATE_DIM / 2 - radius;
    nextLocation = new PVector(0, sphereY, 0);
    location = new PVector(0, sphereY, 0);
    gravityForce = new PVector();
    
    velocity = new PVector();
    nextVelocity = new PVector();
    friction = new PVector();
    
  }
  
  /**
  * This method displays the ball at the current location
  */
  void display() {
    pushMatrix();
    noStroke();
    lights();
    fill(ballColor);
    translate(location.x, location.y, location.z);
    sphere(radius);
    popMatrix();
  }
  
  /**
  * Updates the ball's location, and handle bounces
  */
  final float epsilon = 0.5;
  protected void update(Panel pan) {
    computeLocation(nextLocation, velocity); //Updates nextLocation with velocity
    nextVelocity = velocity.copy();
    
    if(!cylinderCollision()) {
      if(checkEdges(nextLocation, velocity)) {
        if (distance(nextLocation.x,nextLocation.z, location.x, location.z) > epsilon){ //solves the problem of losing points while not moving 
          pan.updateScore(false, velocity.mag()); 
        }
      }
    }else {
      if (distance(nextLocation.x,nextLocation.z, location.x, location.z) > epsilon){
        pan.updateScore(true, velocity.mag()); //the ball hit the cylinder with its velocity
      }
    }
    
    pan.updateVelocity(nextVelocity.mag()); //Updates the velocity value in class Panel
    
    
    addForces_to_Velocity(); //updates nextVelocity with forces
   
    location = nextLocation.copy();
    velocity = nextVelocity.copy();

  }
  
  /**
  * Helper function to compute a new location given a location, depending on the current velocity
  */
  private void computeLocation(PVector loc, PVector vel) {
    loc.add(vel.x * deltaT, 0, vel.z * deltaT);
  }
  
  /*Computes the forces acting on the ball and returns the acceleration for the frame*/
  private PVector computeForces() {
   
    // Here we compute the gravity force
    gravityForce.x = sin(rotateZ) * cos(rotateX) * GRAVITY;
    gravityForce.z = - sin(rotateX) * GRAVITY;
    gravityForce.y = cos(rotateX) * cos(rotateZ) * GRAVITY;
    gravityForce.mult(mass).mult(1000); // set gravity to [Kg * mm/s²]
      
    // Here we compute the friction force
    normalForce = gravityForce.y;
    float mag = normalForce * mu;
    friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(mag); 
    PVector acceleration = new PVector(gravityForce.x, 0, gravityForce.z);
    return acceleration.add(friction).div(this.mass).mult(deltaT);
  }
    
  /**
  * Helper function the permits to compute the new velocity depending on the current forces
  */
  private void addForces_to_Velocity() {
    PVector acceleration = computeForces();
    nextVelocity = nextVelocity.add(acceleration); 
  }
 
  
  
  /**
  * Checks if the given location fits in the boundaries, given its initial velocity and changes nextVelocity accordingly
  */
  private boolean checkEdges(PVector loc, PVector vel) { 
    boolean hit = false;
    if(loc.x + radius > PLATE_DIM / 2f || loc.x - radius < - PLATE_DIM / 2f) {
      nextVelocity.x = (vel.x * -1) * elasticity;
      loc.x = Math.signum(loc.x) * (PLATE_DIM/2f - radius);
      hit = true;
    } 
    
    if(loc.z + radius > PLATE_DIM / 2f || loc.z - radius < - PLATE_DIM / 2f) {
      nextVelocity.z = (vel.z * -1) * elasticity;
      loc.z = Math.signum(loc.z) * (PLATE_DIM/2f - radius);
      hit = true;
    } 
    
    return hit; 
  }
  
  /**
  * Handles cylinder collisions given a certain location of ball, cylinder, and nextVelocity
  */
  private void handleCollision(PVector ballLoc, PVector cyl, PVector nextVel) {
    
      PVector n = ballLoc.copy().sub(cyl).normalize(); //Normal vector from cylinder to ball center 
      nextVel = nextVel.add(velocity.copy().sub(n.copy().mult(2 * velocity.copy().dot(n))).mult(elasticity)); // New Velocity after collision 
      n.setMag(cylinderBaseSize + radius); // n points from cylinder center to 
      
      //This resets the ball to the border of cylinder
     
      ballLoc.x = cyl.x + n.x;
      ballLoc.y = cyl.y;
      ballLoc.z = cyl.z + n.z ;
      
    }
  
  
  /**
  * Iterates on each cylinder and treats each collision seperately, changing the location of the ball accordingly
  */
  private boolean cylinderCollision() {
    PVector potentialVelocity = new PVector(); //Potential velocity after collision
    PVector potentialPosition = nextLocation.copy();
    boolean hit = false;
    int num = 0; // Number of hits
    for(PVector v : cylinders){
      if (distance(potentialPosition.x, potentialPosition.z, v.x, v.y) <= cylinderBaseSize + radius) {
         handleCollision(potentialPosition, new PVector(v.x, sphereY, v.y), potentialVelocity);
         hit = true;
         num++;
      }
    }
    if(hit) {
      
      computeLocation(potentialPosition, potentialVelocity.div(num)); //Computes where the ball should be after collision
      //nextVelocity = potentialVelocity.div(num);
      /*if (num > 1) {
        nextLocation = location.copy();
      }*/
     // computeLocation(, nextVelocity);
      if (checkEdges(potentialPosition, potentialVelocity)){
        nextLocation = location.copy();
        nextVelocity = velocity.copy().mult(-elasticity); //if it touches both the cylinder and edge, make it bounce backwards (solves some bugs)
      } else  {
        nextLocation = potentialPosition.copy();
        nextVelocity = potentialVelocity.div(num);
      }
      
      /*if(checkEdges(potentialPosition, potentialVelocity)){ //Checks if ball bounces out of bounds
         potential = location.copy();
      }*/
    }
  
    return hit;
  }
   
}