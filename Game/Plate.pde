

class Plate {
  void display() {
    pushMatrix();
    scale(1, scaleFactor, 1);
    fill(#2CDE1D);
    box(plateWidth);
    popMatrix();
  }
}