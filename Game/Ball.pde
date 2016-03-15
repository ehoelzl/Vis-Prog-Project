float sphereRadius = 20;
PVector initialVelocity = new PVector();
float sphereY = - sphereRadius - (plateWidth / 2f * scaleFactor);

class Ball {
  private PVector velocity;
  private PVector friction;
  private PVector location;
  
  public Ball() {
    velocity = initialVelocity.copy();
    friction = new PVector();
    location = new PVector(0, sphereY, 0);
  }
  
  public void display() {
    display(location);
  }
  
  public void update() {
    friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    velocity.add(friction);
    location.add(velocity);
  }
  
  private void display(PVector location) {
  pushMatrix();
  lights();
  fill(#FF0505);
  translate(location.x, location.y, location.z);
  sphere(sphereRadius);
  popMatrix();
  }
}