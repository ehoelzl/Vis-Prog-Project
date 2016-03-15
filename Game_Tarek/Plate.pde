class Plate {
  float dims;
  
  Plate(float dim) {
    dims = dim;
  }
  
  void display() {
    pushMatrix();
    stroke(3);
    lights();
    fill(#2CDE1D);
    box(dims,dims * 0.04, dims);
    popMatrix();
  }
  
 }