float sphereRadius = 20;
PVector initialVelocity = new PVector();
float sphereY = - sphereRadius - (plateWidth / 2f * scaleFactor);
float sphereMass = 10;
float bordersLength = 10;

class Ball {
  private PVector velocity;
  private PVector oldVelocity;
  private PVector friction;
  private PVector location;
  private float mass;
  
  public Ball() {
    velocity = initialVelocity.copy();
    oldVelocity = velocity.copy();
    friction = new PVector();
    location = new PVector(0, sphereY, 0);
    mass = sphereMass;
  }
  
  public void display() {
    display(location);
  }
  
  public void update() {
    friction = oldVelocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    
    velocity = gravityForce.copy();
    velocity.add(friction);
    //velocity.z = velocity.z * -1;
    velocity.mult(deltaT / mass);
    velocity.add(oldVelocity);
    velocity.add(friction);
    
    location.add(velocity.x * deltaT, 0, velocity.z * deltaT);
    location.x = Math.min(location.x, plateWidth / 2f - bordersLength);
    location.x = Math.max(location.x, - plateWidth / 2f + bordersLength);
    location.z = Math.min(location.z, plateWidth / 2f - bordersLength);
    location.z = Math.max(location.z, - plateWidth / 2f + bordersLength);
    
    if(location.x >= plateWidth / 2f - bordersLength || location.x <= - plateWidth / 2f + bordersLength) {
      velocity.x = velocity.x * -1;
    }
    if(location.z >= plateWidth / 2f - bordersLength || location.z <= - plateWidth / 2f + bordersLength) {
      velocity.z = velocity.z * -1;
    }
    
    oldVelocity = velocity.copy();

    
    
  }
  
  private void display(PVector location) {
  pushMatrix();
  lights();
  fill(#FF0505);
  translate(location.x, location.y, - location.z);
  print(location.x);
  sphere(sphereRadius);
  popMatrix();
  }
}