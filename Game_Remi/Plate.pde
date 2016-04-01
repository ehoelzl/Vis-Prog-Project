

class Plate {
  private ArrayList<PVector> cylinders;
  private Cylinder cylinder;
  
  public Plate() {
    cylinders = new ArrayList();
    cylinder = new Cylinder();
  }
  
  
  public void addCylinder() {
    cylinders.add(new PVector(mouseX - width / 2f, mouseY - height / 2f)); // add cylinder to the array, called by mousePressed in main
  }
  
  private double distance(float x1, float y1, float x2, float y2) { 
   float distX = Math.abs(x1 - x2);
   float distY = Math.abs(y1 - y2);
   
   return Math.sqrt(distX * distX + distY * distY);
  }
  
  public boolean verifyBoundaries(float x, float y) { //verifies the location of the click 
  
     boolean onBall = distance(ball.location.x, ball.location.z, x, y) <= (sphereRadius + cylinderBaseRadius);
     boolean onCylinder = false;
          
     for(PVector p: cylinders){
      onCylinder = onCylinder || distance(p.x, p.y, x, y) <= 2 * cylinderBaseRadius;
     }
     
     float bound = plateWidth / 2f - cylinderBaseRadius;
     
     return (x < bound && x > - bound && y < bound && y > - bound && !onBall && !onCylinder);
   
   
  }
  
  //Returns normal vector of collision
  public PVector checkCylinderCollision(PVector ballNextLocation) {
    PVector n = ballNextLocation.copy();
    n.y = 0;
    
    for(PVector c : cylinders) {
      if(distance(ballNextLocation.x, ballNextLocation.z, c.x, c.y) <= (sphereRadius + cylinderBaseRadius)) {
        n = n.sub(c.x, 0, c.y);
        return n.normalize();
      }
    }
    
    return null;
  }
  
  public void display() {
    pushMatrix();
    for(PVector p : cylinders) {
      cylinder.display(p.x, 0, p.y);
    }  
    scale(1, scaleFactor, 1);
    fill(#2CDE1D);
    box(plateWidth);
    
    popMatrix();
  }
}