  float rotateX;
  float rotateZ;
class Plate {
  private ArrayList<PVector> cylinders;
  private float dims;
  private Cylinder  cylinder2D = new Cylinder();
  private Cylinder cylinder3D = new Cylinder();
  
  Plate(float dim) {
    dims = dim;
    rotateX = .0;
    rotateZ = .0;
    cylinders = new ArrayList();
    cylinder2D.get2D();
    cylinder3D.get3D();
    
  }
  
  public void display_game() { //displays the plate for playing the game
    rotateX(rotateX);
    rotateZ(rotateZ);
    pushMatrix();
    stroke(3);
    lights();
    fill(#2CDE1D);
    box(dims,dims * 0.04, dims);
    if (!cylinders.isEmpty()){
      for(PVector p : cylinders){
        cylinder3D.display(p.x,0,p.y);
      }
    }
    popMatrix();
  }
   public void display_shift() { // displays the plate for the shift mode.
    pushMatrix();
    stroke(3);
    lights();
    fill(#2CDE1D);
    rect(-dims/2,-dims/2,dims,dims);
    if (!cylinders.isEmpty()){
      for(PVector p : cylinders){
        cylinder2D.display(p.x,p.y,0);
      }
    }
    popMatrix();
 }
 
   
 private double distance(float x1, float y1, float x2, float y2){ 
   float distX = Math.abs(x1 - x2);
   float distY = Math.abs(y1 - y2);
   return Math.sqrt(distX*distX + distY*distY);
 }
 
 public boolean verify_boundaries(float x, float y){ //verifies the location of the click 
   boolean ok = distance(ball.location.x, ball.location.y, x, y) > (2*ball.radius + cylinderBaseSize);
   for(PVector p: cylinders){
       ok = distance(p.x, p.y, x, y) > 2*cylinderBaseSize;
     }
   float bound = dims/2 - cylinderBaseSize;
   return ( x < bound && x >-bound && y<bound && y>-bound && ok);
   
   
 }
  
  public void mousePressed(){
     if (verify_boundaries(mouseX - width/2, mouseY - height/2)){// if the click is correctly placed
       cylinders.add(new PVector(mouseX-width/2, mouseY - height/2)); // add cylinder to method
     }
  }
  public void mouseDragged() { //takes care of changing the angles
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
  
  public void mouseWheel(MouseEvent event) {
    speedFactor += event.getCount();
    speedFactor = max(50, speedFactor);
    speedFactor = min(speedFactor, MAX_SPEED);  }
  
 }