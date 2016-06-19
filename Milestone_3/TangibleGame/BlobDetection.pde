//import java.awt.Polygon;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.SortedSet;
//import java.util.TreeSet;

//class BlobDetection {

//  Polygon quad = new Polygon();
//  /** Create a blob detection instance with the four corners of the Lego board.
//  */

//  BlobDetection(PVector c1, PVector c2, PVector c3, PVector c4) {
//    quad.addPoint((int) c1.x, (int) c1.y);
//    quad.addPoint((int) c2.x, (int) c2.y);
//    quad.addPoint((int) c3.x, (int) c3.y);
//    quad.addPoint((int) c4.x, (int) c4.y);
  
//  }
//  /** Returns true if a (x,y) point lies inside the quad
//  */
//  boolean isInQuad(int x, int y) {return quad.contains(x, y);}
//  PImage findConnectedComponents(PImage input){
//  // First pass: label the pixels and store labels' equivalences
//  int [] labels= new int [input.width * input.height];
//  List<TreeSet<Integer>> labelsEquivalences = new ArrayList<TreeSet<Integer>>();
//  int currentLabel=1;
  
//  for(int x = 0; x < input.width; x++) {
//    for(int y = 0; y < input.height; y++) {
//      int lab1, lab2, lab3, lab4 = 0;
//      if(isInQuad(x - 1, y - 1)) {
//        lab1 = labels[x - 1 + input.width * (y - 1)];
//      }
//      if(isInQuad(x, y - 1)) {
//        lab2 = labels[x + input.width * (y - 1)];
//      }
//      if(isInQuad(x + 1, y - 1)) {
//        lab3 = labels[x + 1 + input.width * (y - 1)];
//      }
//      if(isInQuad(x - 1, y)) {
//        lab4 = labels[x - 1 + input.width * y];
//      }
      
//      if(lab1 == lab2 && lab2 == lab3 && lab3 == lab4) {
//        labels[x + input.width * y] = lab1;
//      } else {
//        int[] labs = { lab1, lab2, lab3, lab4};
//        Java.util.Array.sort(labs);
//        labels[x + input.width * y] = labs[0];
//        TreeSet<Integer> eq = new TreeSet(labs);
        
//      }
      
//    }
//  }
  
//  // Second pass: re-label the pixels by their equivalent class
//  // TODO!
//  // Finally, output an image with each blob colored in one uniform color.
//  // TODO!
//  }
//}