/**
* The class Ball permits to handle all of the ball's functionalities
*/
class Ball {
  
  private float radius; // mm
  private float sphereY; // The y position of the ball, permits to the ball to be on top of the plate
  private PVector location;
  private PVector nextLocation;
  private PVector oldLocation;
  private PVector gravityForce;  //Kg * mm / s² 
  private PVector velocity; //mm/s
<<<<<<< HEAD
  private PVector nextVelocity;
  private PVector acceleration; // mm/s²
=======
  private PVector oldVelocity;
  private PVector acceleration; // mm / s²
>>>>>>> a84cd97aa08b29d73170269f57d589ac9aff42ab
  private float normalForce = 0;
  private float mu = 0.25;
  private PVector friction;
  private float mass;
<<<<<<< HEAD
  private float elasticity = 0.6;
=======
  private float elasticity = 0.8; // each bounce on a cylinder/boudary absorbs ((1 - 'elasticity') * 100) % of the force 
>>>>>>> a84cd97aa08b29d73170269f57d589ac9aff42ab
  
  /**
  * The constructor of the class Ball, initializes the pertinent variables, given a radius and a mass
  */
  Ball(float rad, float mass) { 
    this.mass = mass;
    radius = rad;
    sphereY = - .04 * PLATE_DIM / 2 - radius;
    nextLocation = new PVector(0, sphereY, 0);
    location = new PVector(0, sphereY, 0);
    oldLocation = location.copy();
    gravityForce = new PVector();
    
<<<<<<< HEAD
    velocity = new PVector(0,0,0);
    nextVelocity = new PVector(0,0,0);
    acceleration = new PVector(0,0,0);
    friction = new PVector(0,0,0);
=======
    velocity = new PVector();
    oldVelocity = new PVector();
    acceleration = new PVector();
    friction = new PVector();
    
>>>>>>> a84cd97aa08b29d73170269f57d589ac9aff42ab
  }
  
  /**
  * This method permits to display the ball at the current location
  */
  void display() {
    pushMatrix();
    noStroke();
    lights();
    fill(#F5A800);
    translate(location.x, location.y, location.z);
    sphere(radius);
    popMatrix();
  }
  
<<<<<<< HEAD
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
=======
  /**
  * Updates the ball's location, and handle bounces
  */
  protected void update() {
    computeVelocity();
    computeLocation(nextLocation);
    if(!cylinderCollision()) {
      if(checkEdges(nextLocation)) {
        computeLocation(location);
      } else {
        location = nextLocation.copy();
      }
    }
    oldLocation = location.copy();
    nextLocation = location.copy();
    oldVelocity = velocity.copy();
  }
  
  /**
  * Helper function to compute a new location given a location, depending on the current velocity
  */
  private void computeLocation(PVector loc) {
    loc.add(velocity.x * deltaT, 0, velocity.z * deltaT);
>>>>>>> a84cd97aa08b29d73170269f57d589ac9aff42ab
  }
  
  private void computeForces() {
   
    // Here we compute the gravity force
    gravityForce.x = sin(rotateZ) * cos(rotateX) * GRAVITY;
    gravityForce.z = - sin(rotateX) * GRAVITY;
    gravityForce.y = cos(rotateX) * cos(rotateZ) * GRAVITY;
    gravityForce.mult(mass).mult(1000); // set gravity to Kg * mm/s² 
      
    // Here we compute the friction force
    normalForce = gravityForce.y;
    float mag = normalForce * mu;
    friction = oldVelocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(mag); 
  }
    
<<<<<<< HEAD
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
=======
  /**
  * Helper function the permits to compute the new velocity depending on the current forces
  */
  private void computeVelocity() {
    computeForces();
    velocity = new PVector(gravityForce.x, 0, gravityForce.z);
    velocity.add(friction).div(mass);
    velocity.mult(deltaT);
    velocity.add(oldVelocity); 
  }
 
  
  
  /**
  * Checks if the given location fits in the boundaries
  */
  private boolean checkEdges(PVector location) { 
    boolean hit = false;
    if(location.x + radius > PLATE_DIM / 2f || location.x - radius < - PLATE_DIM / 2f) {
      velocity.x = (oldVelocity.x * -1) * elasticity;
      hit = true;
    } 
    
    if(location.z + radius > PLATE_DIM / 2f || nextLocation.z - radius < - PLATE_DIM / 2f) {
      velocity.z = (oldVelocity.z * -1) * elasticity;
      hit = true;
    } 
    
    return hit; 
  }
  
  /**
  * Handles cylinder collisions given a certain location of ball and collision
  */
  private void handleCollision(PVector ball, PVector cyl) {
    
      PVector n = nextLocation.sub(cyl).normalize(); //Normal vector from cylinder to ball center 
      velocity = oldVelocity.sub(n.copy().mult(2 * oldVelocity.dot(n))).mult(elasticity); // New Velocity after collision 
      n.setMag(cylinderBaseSize + radius); // n points from cylinder center to 
      
      //This resets the ball to the border of cylinder
      nextLocation.x = cyl.x + n.x;
      nextLocation.y = cyl.y;
      nextLocation.z = cyl.z + n.z;
      
      
      //velocity = newVelocity.copy().mult(elasticity); //Sets the velocity 
      
      //Check if cylinder bounce throws the ball out of bounds
      PVector nextLocationCopy = nextLocation.copy();
      computeLocation(nextLocation);
      if(checkEdges(nextLocation)) {
        nextLocation = nextLocationCopy.copy();
      }
    }
  
  
  /**
  * Iterates on each cylinder and treats each collision seperately, changing the location of the ball accordingly
  */
  private boolean cylinderCollision() {
    boolean hit = false;
    for(PVector v : cylinders){

      if (distance(nextLocation.x, nextLocation.z, v.x, v.y) <= cylinderBaseSize + radius) {
         handleCollision(nextLocation, new PVector(v.x, nextLocation.y, v.y));
         hit = true;
>>>>>>> a84cd97aa08b29d73170269f57d589ac9aff42ab
      }
    }
    computeLocation(location);
    if(checkEdges(location)) {
      location = oldLocation.copy();
    }
    return hit;
  }
   
}