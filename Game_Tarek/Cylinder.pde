
float cylinderBaseSize = 15;
float cylinderHeight = 25;
int cylinderResolution = 40;
color couleur = #1932FC;

class Cylinder {
    float angle;
    float[] x = new float[cylinderResolution + 1];
    float[] y = new float[cylinderResolution + 1];
    private PShape openCylinder, bottomSurface, topSurface;
    
    Cylinder(){
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
    }
    
    public void get2D(){ // set current cylinderShape to a 2D representation
      openCylinder.beginShape(QUAD_STRIP);
      topSurface.beginShape(TRIANGLE_FAN);
      bottomSurface.beginShape(TRIANGLE_FAN);
      openCylinder.noStroke();
      openCylinder.fill(couleur);
      topSurface.noStroke();
      bottomSurface.noStroke();
      topSurface.fill(couleur);
      bottomSurface.fill(couleur);
      topSurface.vertex(0,0,0);
      topSurface.vertex(0,0,0);
      bottomSurface.vertex(0,0, cylinderHeight);
  
      for(int i = 0; i < x.length; i++) {
        openCylinder.vertex(x[i], y[i] , 0);
        openCylinder.vertex(x[i], y[i], cylinderHeight);
        topSurface.vertex(x[i], y[i], 0);
        bottomSurface.vertex(x[i], y[i], cylinderHeight);
      }
      openCylinder.endShape();
      topSurface.endShape();
      bottomSurface.endShape();
    }
    
    public void get3D(){ // set current cylinderShape to a 2D representation
      openCylinder.beginShape(QUAD_STRIP);
      topSurface.beginShape(TRIANGLE_FAN);
      bottomSurface.beginShape(TRIANGLE_FAN);
      openCylinder.noStroke();
      openCylinder.fill(couleur);
      topSurface.noStroke();
      bottomSurface.noStroke();
      topSurface.fill(couleur);
      bottomSurface.fill(couleur);
      topSurface.vertex(0,0,0);
      bottomSurface.vertex(0,-cylinderHeight, 0);
  
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
    
    public void display(float x, float y ,float z){ // display the cylinder at the correct location //<>//
      pushMatrix();
      translate(x,y,z);
      shape(topSurface);
      shape(bottomSurface);
      shape(openCylinder);
      popMatrix();
    }
  
  
  
  
}