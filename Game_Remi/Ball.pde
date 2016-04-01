final static float sphereY = - sphereRadius - (plateWidth / 2f * scaleFactor);
final static float sphereMass = 10;
final static float bordersLength = 10;

PVector initialVelocity = new PVector();

class Ball {
  private PVector velocity;
  private PVector oldVelocity;
  private PVector friction;
  private PVector location;
  private PVector potentialLocation;
  private float mass;
  
  public Ball() {
    velocity = new PVector();
    oldVelocity = new PVector();
    friction = new PVector();
    location = new PVector(0, sphereY, 0);
    potentialLocation = location.copy();
    mass = sphereMass;
  }
  
  public void update() {    
        
    computeVelocity();
    
    computeLocation(potentialLocation);
    
    PVector n = plate.checkCylinderCollision(potentialLocation);
    
    if(n != null) {
      velocity = velocity.sub(n.mult(2 * (velocity.dot(n))));
      computeLocation(location);
    } else {
      if(outOfBounds(potentialLocation)) {
        computeLocation(location);
      } else {
        location = potentialLocation.copy();
      }
    }
        
    location.x = Math.min(location.x, plateWidth / 2f);
    location.x = Math.max(location.x, - plateWidth / 2f);
    location.z = Math.min(location.z, plateWidth / 2f);
    location.z = Math.max(location.z, - plateWidth / 2f);
    
    potentialLocation = location.copy();
       
    oldVelocity = velocity.copy();
    
    print(velocity.mag()+" ");
    
  }
  
  private void computeLocation(PVector loc) {
    loc.add(velocity.x * deltaT, 0, velocity.z * deltaT);   
  }
  
  private void computeVelocity() {
    computeFriction();
    velocity = gravityForce.copy();
    velocity.add(friction);
    velocity.mult(deltaT / mass);
    velocity.add(oldVelocity);
    
    }
  
  private void computeFriction() {
    friction = oldVelocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    
  }
  
  private boolean outOfBounds(PVector loc) {
    boolean hitEdge = false;
    
    if(loc.x >= plateWidth / 2f - sphereRadius || loc.x <= - (plateWidth / 2f - sphereRadius)) {
      velocity.x = velocity.x * -1;
      hitEdge = true;
    }
    if(loc.z >= plateWidth / 2f - sphereRadius || loc.z <= - (plateWidth / 2f - sphereRadius)) {
      velocity.z = velocity.z * -1;
      hitEdge = true;
    }
    //print(hitEdge);
    return hitEdge;
  }
  
  private void display() {
    pushMatrix();
    lights();
    fill(#FF0505);
    translate(location.x, location.y, location.z);
    sphere(sphereRadius);
    popMatrix();
  }
}