  float rotateX;
  float rotateZ;
  ArrayList<PVector> cylinders;
class Plate {
  private float dims;
  private Cylinder cylinder = new Cylinder();
  
  /* Creates a Square plate of dimensions dims */
  Plate(float dim) { 
    dims = dim;
    rotateX = .0;
    rotateZ = .0;
    cylinders = new ArrayList();
    
  }
  
  /* Displays the plate for both modes */
  public void display() { 
    if(!shiftMode) {
      rotateX(rotateX);
      rotateZ(rotateZ);
    }
    pushMatrix();
    stroke(3);
    lights();
    fill(#2CDE1D);
    box(dims,dims * 0.04, dims);
    if (!cylinders.isEmpty()){
      for(PVector p : cylinders){
        cylinder.display(p.x,0,p.y);
      }
    }
    popMatrix();
  }
   
 /* Verifies the location of the click for Cylinder insertion */
 public boolean verify_boundaries(float x, float y){ 
   boolean ok = distance(ball.location.x, ball.location.z, x, y) > (ball.radius + cylinderBaseSize);
   for(PVector p: cylinders){
       ok = ok && (distance(p.x, p.y, x, y) > 2*cylinderBaseSize);
     }
   float bound = dims/2 - cylinderBaseSize;
   return ( x < bound && x >-bound && y<bound && y>-bound && ok);
   
   
 }
  
  /* Treats the mouse Pressed event (adds a cylinder)*/
  public void mousePressed(){
     if (verify_boundaries(mouseX - width/2, mouseY - height/2) && shiftMode){// if the click is correctly placed
       cylinders.add(new PVector(mouseX-width/2, mouseY - height/2)); // add cylinder to method
     }
  }
  
  /* Treats the mouse dragged event */
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
  
  /* Treats the mousewheel event */
  public void mouseWheel(MouseEvent event) {
    speedFactor += event.getCount();
    speedFactor = max(50, speedFactor);
    speedFactor = min(speedFactor, MAX_SPEED);  }
  
 }