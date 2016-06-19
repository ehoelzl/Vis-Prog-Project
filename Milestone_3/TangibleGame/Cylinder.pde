float cylinderBaseSize = 30;
float cylinderHeight = 50;
int cylinderResolution = 40;
color cylinderColor = #12F207;

/**
* The Cylinder class permits to create some cylinders and display them
*/
class Cylinder {
    private float angle;
    private float[] x = new float[cylinderResolution + 1];
    private float[] y = new float[cylinderResolution + 1];
    private PShape openCylinder, bottomSurface, topSurface;
   
    /**
    * The Cylinder constructor that permits to create the shape
    */
    Cylinder() { 
      openCylinder = new PShape();
      bottomSurface = new PShape();
      topSurface = new PShape();
      
      for(int i = 0; i < x.length; i++) {
        angle = (TWO_PI / cylinderResolution) * i;
        x[i] = sin(angle) * cylinderBaseSize;
        y[i] = cos(angle) * cylinderBaseSize;
       }
        openCylinder = createShape();
        bottomSurface = createShape();
        topSurface = createShape();
        sketchCylinder();
    }
    
    /**
    * Sketches the Cylinder to use, the open cylinder represents the cylinder body, topSurface and bottomSurface are the two bases 
    */
    private void sketchCylinder(){ 
      openCylinder.beginShape(QUAD_STRIP);
      topSurface.beginShape(TRIANGLE_FAN);
      bottomSurface.beginShape(TRIANGLE_FAN);
      openCylinder.noStroke();
      openCylinder.fill(cylinderColor);
      topSurface.noStroke();
      bottomSurface.noStroke();
      topSurface.fill(cylinderColor);
      bottomSurface.fill(cylinderColor);
      topSurface.vertex(0, 0, 0);
      bottomSurface.vertex(0, - cylinderHeight, 0);
  
      for(int i = 0; i < x.length; i++) {
        openCylinder.vertex(x[i], 0 , y[i]);
        openCylinder.vertex(x[i], -cylinderHeight, y[i]);
        topSurface.vertex(x[i], 0, y[i]);
        bottomSurface.vertex(x[i], -cylinderHeight, y[i]);
      }
      openCylinder.endShape();
      topSurface.endShape();
      bottomSurface.endShape();
    }
    
    /** 
    * Displays the cylinder on the given position 
    */
    public void display(float x, float y ,float z){ // display the cylinder at the correct location
      pushMatrix();
      translate(x, y, z);
      shape(topSurface);
      shape(bottomSurface);
      shape(openCylinder);
      popMatrix();
    }
  
  
  
  
}