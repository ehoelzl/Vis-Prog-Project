/**
* This class represents our plate
**/

class Plate {
  private ArrayList<PVector> cylinders;
  private Cylinder cylinder;
  
  public Plate() {
    cylinders = new ArrayList(); // The list of cylinders
    cylinder = new Cylinder(); 
  }
  
  
  /**
  * This function is called by Game when in shiftMode we click on the plate, adds a cylinder to our list
  **/
  public void addCylinder() {
    cylinders.add(new PVector(mouseX - width / 2f, mouseY - height / 2f));
  }
  
  /**
  * Helper function that calculates the 2D distance between two points
  **/
  private double distance(float x1, float y1, float x2, float y2) { 
   float distX = Math.abs(x1 - x2);
   float distY = Math.abs(y1 - y2);
   
   return Math.sqrt(distX * distX + distY * distY);
  }
  
  /**
  * This helper function is used to check if the click for adding a cylinder is licite, i.e. is on the plate,
  * not on the ball and not on another cylinder
  **/
  public boolean verifyBoundaries(float x, float y) { 
  
     boolean onBall = distance(ball.location.x, ball.location.z, x, y) <= (sphereRadius + cylinderBaseRadius);
     boolean onCylinder = false;
          
     for(PVector p: cylinders){
      onCylinder = onCylinder || distance(p.x, p.y, x, y) <= 2 * cylinderBaseRadius;
     }
     
     float bound = plateWidth / 2f - cylinderBaseRadius;
     
     return (x < bound && x > - bound && y < bound && y > - bound && !onBall && !onCylinder);
   
   
  }
  
  /**
  * This function checks if the ball is going to hit a cylinder, if it does, returns the normal vector of this cylinder 
  * in the ball's direction
  **/
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
  
  /**
  * the display function, used to see our plate on the screen
  **/
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