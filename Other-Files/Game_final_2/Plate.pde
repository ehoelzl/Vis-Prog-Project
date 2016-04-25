float rotateX;
float rotateZ;
ArrayList<PVector> cylinders;
color plateColor = #2CDE1D;

/**
* The class Plate, that permits to handle the plate functionnalities
*/
class Plate {
  private float dim;
  private Cylinder cylinder;
  
  /** 
  * The constructor for the plate class, permits to initialize everything
  */
  Plate(float dim) { 
    this.dim = dim;
    rotateX = .0;
    rotateZ = .0;
    cylinder = new Cylinder();
    cylinders = new ArrayList();
    
  }
  
  /**
  * Displays the plate for both modes
  */
  public void display() { 
    if(!shiftMode) {
      rotateX(rotateX);
      rotateZ(rotateZ);
    }
    pushMatrix();
    stroke(3);
    lights();
    fill(plateColor);
    box(dim, dim * 0.04, dim);
    if (!cylinders.isEmpty()){
      for(PVector p : cylinders){
        cylinder.display(p.x,0,p.y);
      }
    }
    popMatrix();
  }
   
 /**
 * Verifies the location of the click for Cylinder insertion
 */
 public boolean verifyBoundaries(float x, float y) { 
   boolean ok = distance(ball.location.x, ball.location.z, x, y) > (ball.radius + cylinderBaseSize); // This line permits to check if the potential cylinder overlap on our ball
   for(PVector p: cylinders){
       ok = ok && (distance(p.x, p.y, x, y) > 2 * cylinderBaseSize); // This permits to check if the potential cylinder does not overlap another cylinder
     }
   float bound = dim / 2f - cylinderBaseSize;
   return ( x < bound && x > - bound && y < bound && y > - bound && ok); // The above verifications plus the fact that the cylinder must be completely on the plate give us the boolean to return
   
   
 }
  
  /** 
  * handles the mouse Pressed event (adds a cylinder)
  */
  public void mousePressed() {
     if (verifyBoundaries(mouseX - width / 2f, mouseY - height / 2f) && shiftMode) { // if the click is correctly placed
       cylinders.add(new PVector(mouseX - width / 2f, mouseY - height / 2f)); // add cylinder to method
     }
  }
  
  /**
  * Handles the mouse dragged event 
  */
  public void mouseDragged() {
    if(pmouseY > mouseY) { //rotateX
      rotateX = min(rotateX + PI / speedFactor, PI / 6);
    } else {
      if(pmouseY < mouseY) {
        rotateX = max(rotateX - PI / speedFactor, -PI / 6);
      }
    }
    
    if(pmouseX < mouseX) { //rotateZ
      rotateZ = min(rotateZ + PI / speedFactor, PI / 6);
    } else {
      if(pmouseX > mouseX) {
        rotateZ = max(rotateZ - PI / speedFactor, -PI / 6);
      }
    }
  }
  
  /** 
  * Handles the mousewheel event 
  */
  public void mouseWheel(MouseEvent event) {
    speedFactor += event.getCount();
    speedFactor = max(50, speedFactor);
    speedFactor = min(speedFactor, MAX_SPEED);  
  }
}