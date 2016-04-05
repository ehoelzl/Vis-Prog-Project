/**
* This class represents our ball
*
**/

final static float sphereY = - sphereRadius - (plateWidth / 2f * scaleFactor);
final static float bordersLength = 10;

class Ball {
  private PVector velocity;
  private PVector oldVelocity;
  private PVector friction;
  private PVector location;
  private PVector potentialLocation;
  private PVector oldLocation;
  private float mass;
  private float normalForce;
  private float frictionMagnitude;
  
  public Ball() {
    velocity = new PVector();
    oldVelocity = new PVector();
    friction = new PVector();
    location = new PVector(0, sphereY, 0);
    oldLocation = location.copy();
    potentialLocation = location.copy();
    mass = sphereMass;
    normalForce = 0;
    frictionMagnitude = 0;
  }
  
  /**
  * This functions permits to update the ball's location before calling display
  **/
  public void update() {    
        
    computeVelocity();
    
    computeLocation(potentialLocation);
    
    PVector c = plate.checkCylinderCollision(potentialLocation);
     
    if(c != null) {
      PVector n = potentialLocation.sub(c.x, sphereY, c.z);
      n.normalize();
      velocity = velocity.sub(n.copy().mult(2 * (velocity.dot(n))));
      n.setMag(cylinderBaseRadius + sphereRadius);
      c.add(n);
      location = c.copy();
      computeLocation(location);
      if(outOfBounds(location)) { 
        location = oldLocation.copy();
      }
      
    } else {
      if(outOfBounds(potentialLocation)) {
        computeLocation(location);
      } else {
        location = potentialLocation.copy();
      }
    }
    
    potentialLocation = location.copy();
    
    oldLocation = location.copy();
    
       
    oldVelocity = velocity.copy();
        
  }
  
  /**
  * This function computes the location the given vector will have given the current velocity
  **/
  private void computeLocation(PVector loc) {
    loc.add(velocity.x * deltaT, 0, velocity.z * deltaT);   
  }
  
  /**
  * This function computes the velocity based on the gravity and friction forces
  **/
  private void computeVelocity() {
    computeFriction();
    velocity = new PVector(gravityForce.x, 0, gravityForce.z);
    velocity.add(friction.div(mass));
    velocity.mult(deltaT);
    velocity.add(oldVelocity);   
    }
  
  /**
  * Helper function that computes the friction for this frame
  **/
  private void computeFriction() {
    normalForce = gravityForce.y;
    frictionMagnitude = normalForce * mu;
    friction = oldVelocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    
  }
  
  /**
  * This function permits to check if the given location is out of the plate and returns true if it is and false otherwise
  **/
  private boolean outOfBounds(PVector loc) {
    boolean hitEdge = false;
    
    if(loc.x >= plateWidth / 2f - sphereRadius || loc.x <= - (plateWidth / 2f - sphereRadius)) {
      velocity.x = oldVelocity.x * -1;
      hitEdge = true;
    }
    if(loc.z >= plateWidth / 2f - sphereRadius || loc.z <= - (plateWidth / 2f - sphereRadius)) {
      velocity.z = oldVelocity.z * -1;
      hitEdge = true;
    }
    return hitEdge;
  }
  
  /**
  * The display function, used to display the ball on the screen
  **/
  private void display() {
    pushMatrix();
    lights();
    fill(#FF0505);
    translate(location.x, location.y, location.z);
    sphere(sphereRadius);
    popMatrix();
  }
}
