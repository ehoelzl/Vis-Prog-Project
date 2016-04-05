/**
* This class represents a cylinder
**/


static final float cylinderBaseRadius = 15;
static final float cylinderHeight = 25;
static final int cylinderResolution = 40;
static final color cylinderColor = #1932FC;

class Cylinder {
  private float angle;
  private float[] x = new float[cylinderResolution + 1];
  private float[] y = new float[cylinderResolution + 1];
  private PShape openCylinder, bottomSurface, topSurface;
    
  public Cylinder(){
    openCylinder = new PShape();
    bottomSurface = new PShape();
    topSurface = new PShape();
      
    for(int i = 0; i < x.length; i++) {
      angle = (TWO_PI / cylinderResolution) * i;
      x[i] = sin(angle) * cylinderBaseRadius;
      y[i] = cos(angle) * cylinderBaseRadius;
    }
    openCylinder = createShape();
    bottomSurface = createShape();
    topSurface = createShape();
    
    setCylinder();
    
}
  /**
  * This function creates the cylinder (shape)
  **/
  public void setCylinder() { 
    openCylinder.beginShape(QUAD_STRIP);
    topSurface.beginShape(TRIANGLE_FAN);
    bottomSurface.beginShape(TRIANGLE_FAN);
    
    openCylinder.noStroke();
    openCylinder.fill(cylinderColor);
    topSurface.noStroke();
    bottomSurface.noStroke();
    topSurface.fill(cylinderColor);
    bottomSurface.fill(cylinderColor);
    
    topSurface.vertex(0,0,0);
    bottomSurface.vertex(0,-cylinderHeight, 0);
  
    for(int i = 0; i < x.length; i++) {
      openCylinder.vertex(x[i], 0 , y[i]);
      openCylinder.vertex(x[i], - cylinderHeight, y[i]);
      topSurface.vertex(x[i], 0, y[i]);
      bottomSurface.vertex(x[i], - cylinderHeight, y[i]);
    }
    
    openCylinder.endShape();
    topSurface.endShape();
    bottomSurface.endShape();
  }
    
  /**
  * Function use to display a cylinder given its position
  **/
  public void display(float x, float y , float z) { 
    pushMatrix();
    
    translate(x,y,z);
    shape(topSurface);
    shape(bottomSurface);
    shape(openCylinder);
    
    popMatrix();
  }
  
}