import processing.video.*;
import java.util.Collections;
import java.util.Random;

PImage sobel;
PImage hough;

float lowerHue = 75; //96
float upperHue = 132.28; //140
float lowerBrightness = 54.71;  //19
float upperBrightness = 192.84; // 171
float lowerSaturation = 88.71; // 58
float upperSaturation = 255; // 256
float lowerIntensity = 20;
float upperIntensity = 150;
int nLines = 4;
float discretizationStepsPhi = .06f;
float discretizationStepsR = 2.5f;

int phiDim;
int rDim;

PVector previousAngles = new PVector();

QuadGraph graph;
TwoDThreeD nik;


//void draw() {
//  original.resize(resizedWidth, resizedHeight);
//  sobel = createSobel(gaussianBlur(thresholding(original)));
//  int[] accumulator = houghAccumulator(sobel);
//  hough = houghImage(accumulator);
  
//  hough.resize(resizedWidth, resizedHeight);
  
//  image(original, 0, 0);

//  getIntersections(lines(nLines, accumulator));
  
//  image(sobel, original.width, 0);
//  image(hough, 2 * original.width, 0);

//}
PImage original;

PVector getBoardAngles(PImage originalBis) {
  graph = new QuadGraph();
  nik = new TwoDThreeD(originalBis.width, originalBis.height);
  rDim = (int) (((originalBis.width + originalBis.height) * 2 + 1) / discretizationStepsR);
  phiDim = (int) (Math.PI / discretizationStepsPhi);
  original = originalBis;
  sobel = createSobel(intensityThresholding(gaussianBlur(thresholding(original))));
  
  int[] accumulator = houghAccumulator(sobel);
  ArrayList<PVector> intersections = drawIntersectionsAndQuads(lines(nLines, accumulator));
 
  if(intersections.size() >= 4) {
    PVector angles = nik.get3DRotations(graph.sortCorners(intersections));
    previousAngles = angles.copy();
    //print(Math.toDegrees(angles.x) + " " + Math.toDegrees(angles.y));
    return angles; 
  }
  return previousAngles;

}

PImage thresholding(PImage img) {
  PImage res = createImage(img.width, img.height, ALPHA);
  
  
  img.loadPixels();
  res.loadPixels();
  
  for(int i = 0; i < img.width * img.height; i++) {
    if(hue(img.pixels[i]) >= lowerHue && hue(img.pixels[i]) <= 
      upperHue && brightness(img.pixels[i]) >= lowerBrightness && brightness(img.pixels[i]) <= 
      upperBrightness && saturation(img.pixels[i]) >= lowerSaturation && saturation(img.pixels[i]) <= 
      upperSaturation) {
        res.pixels[i] = img.pixels[i];
     } else {
        //res.pixels[i] = color(0, 0, 0);
        res.pixels[i] = color(0, 0, 0);
     }
  }
  res.updatePixels();
  return res;
}

PImage gaussianBlur(PImage img) {
  
  float[][] kernel = { { 9, 12, 9 },
                     { 12, 15, 12 },
                     { 9, 12, 9 }};
                       
  float weight = 4 * 9 + 4 * 12 + 15;
  
  int sum = 0;
 
  int N = 3; 
 
  img.loadPixels();
  
  for(int x = N / 2; x < img.width - N / 2; x++) {
    for(int y =  N / 2; y < img.height - N / 2; y++) {
      sum = 0;
        for(int i = 0; i < N; i++) {
          for(int j = 0; j < N; j++) {
            sum += kernel[i][j] * 
            brightness(img.pixels[(y - N / 2 + j) * img.width + (x - N / 2 + i)]);
           }
         }
         img.pixels[y * img.width + x] = color(sum / weight);
      }
   }
   img.updatePixels();
   return img;
  
  }
  
PImage intensityThresholding(PImage img) {
  img.loadPixels();
  for(int i = 0; i < img.width * img.height; i++) {
    if(!(brightness(img.pixels[i]) <= upperIntensity && brightness(img.pixels[i]) >= lowerIntensity)) {
      img.pixels[i] = color(0, 0, 0);
    } 
  }
  
  img.updatePixels();
  
  return img;
}

PImage createSobel(PImage img) {
  
  float[][] hKernel = { { 0,  1, 0 },
                        { 0,  0, 0 },
                        { 0, -1, 0 } };
                        
  float[][] vKernel = { { 0,  0,  0  },
                        { 1,  0, -1 },
                        { 0,  0,  0  } };
                        
  PImage result = createImage(img.width, img.height, ALPHA);
  
  result.loadPixels();
  img.loadPixels();
  
  for (int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(0);
  }
  
  img.loadPixels();
  float[] buffer = new float[img.width * img.height];
  
  float weight = 1f;
  
  int N = 3;
  int sum_v = 0;
  int sum_h = 0;
  int sum = 0;
  float max = 0;
   for(int x = N / 2; x < img.width - N / 2; x++) {
     for(int y =  N / 2; y < img.height - N / 2; y++) {
       sum_v = 0;
       sum_h = 0;
       sum = 0;
       for(int i = 0; i < N; i++) {
         for(int j = 0; j < N; j++) {
           sum_v += vKernel[i][j] * 
           brightness(img.pixels[(y - N / 2 + j) * img.width + (x - N / 2 + i)]);
           
           sum_h += hKernel[i][j] * 
           brightness(img.pixels[(y - N / 2 + j) * img.width + (x - N / 2 + i)]);
         }
       }
       sum = (int)sqrt(sum_v * sum_v + sum_h * sum_h);
       if(sum_v > max) { max = sum_v; }
       if(sum_h > max) { max = sum_h; }
       buffer[y * img.width + x] = sum / weight;
     }
   }
  for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
    for (int x = 2; x < img.width - 2; x++) { // Skip left and right
      if (buffer[y * img.width + x] > (max * 0.3f)) { // 30% of the max
        result.pixels[y * img.width + x] = color(255);
      } else {
        result.pixels[y * img.width + x] = color(0);
      }
    }
  }
  result.updatePixels();
  return result;
  
}

int[] houghAccumulator(PImage edgeImg) {
  
  edgeImg.loadPixels();


  
  float[] tabSin = new float[phiDim];
  float[] tabCos = new float[phiDim];
  float ang = 0;
  //float inverseR = 1.f / discretizationStepsR;
  for (int accPhi = 0; accPhi < phiDim; ang += discretizationStepsPhi, accPhi++) {
    // we can also pre-multiply by (1/discretizationStepsR) since we need it in the Hough loop
    tabSin[accPhi] = (float) (Math.sin(ang) / discretizationStepsR);
    tabCos[accPhi] = (float) (Math.cos(ang) / discretizationStepsR);
  }
  // our accumulator (with a 1 pix margin around)
  int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];
  
  // Fill the accumulator: on edge points (ie, white pixels of the edge
  // image), store all possible (r, phi) pairs describing lines going
  // through the point.
  for (int y = 0; y < edgeImg.height; y++) {
    for (int x = 0; x < edgeImg.width; x++) {
      // Are we on an edge?
      if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
        for(int i = 0; i < phiDim; i++) {
          //float phi = i * discretizationStepsPhi;
          //double r = x * cos(phi) + y * sin(phi);
          //r /= discretizationStepsR;
          float r = x * tabCos[i] + y * tabSin[i];
          r += (rDim - 1) / 2f;
          accumulator[((i + 1) * (rDim + 2) + (int)r + 1)] += 1;
        }
        // ...determine here all the lines (r, phi) passing through
        // pixel (x,y), convert (r,phi) to coordinates in the
        // accumulator, and increment accordingly the accumulator.
        // Be careful: r may be negative, so you may want to center onto
        // the accumulator with something like: r += (rDim - 1) / 2
      }
    }
  }
  return accumulator;
}

PImage houghImage(int[] accumulator) {
  PImage res = createImage(rDim + 2, phiDim + 2, ALPHA);
  res.loadPixels();
  
  for(int i = 0; i < accumulator.length; i++) {
    res.pixels[i] = color(min(255, accumulator[i]));
  }
  res.updatePixels();
  return res;
}

ArrayList<PVector> lines(int nLines, int[] accumulator) {
  int minVotes = 120;
  ArrayList<Integer> bestCandidates = new ArrayList();
  
  // size of the region we search for a local maximum
  int neighbourhood = 30;
  // only search around lines with more that this amount of votes
  // (to be adapted to your image)
  for (int accR = 0; accR < rDim; accR++) {
    for (int accPhi = 0; accPhi < phiDim; accPhi++) {
      // compute current index in the accumulator
      int idx = (accPhi + 1) * (rDim + 2) + accR + 1;
      if (accumulator[idx] > minVotes) {
        boolean bestCandidate=true;
        // iterate over the neighbourhood
          for(int dPhi=-neighbourhood/2; dPhi < neighbourhood/2+1; dPhi++) {
            // check we are not outside the image
            if( accPhi+dPhi < 0 || accPhi+dPhi >= phiDim) continue;
              for(int dR=-neighbourhood/2; dR < neighbourhood/2 +1; dR++) {
                // check we are not outside the image
                if(accR+dR < 0 || accR+dR >= rDim) continue;
                  int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
                  if(accumulator[idx] < accumulator[neighbourIdx]) {
                    // the current idx is not a local maximum!
                    bestCandidate = false;
                    break;
                  }
              }
              if(!bestCandidate) break;
            }
            if(bestCandidate) {
            // the current idx *is* a local maximum
            bestCandidates.add(idx);
            }
      }
    }
  }
  
  bestCandidates.sort(new HoughComparator(accumulator));
  
  int i = 0;
  ArrayList<PVector> lines = new ArrayList();
 
  while(i < nLines && i < bestCandidates.size()) {
     int idx = bestCandidates.get(i);
     i++;
     int accPhi = (int) (idx / (rDim + 2)) - 1;
     int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
     float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
     float phi = accPhi * discretizationStepsPhi;
     lines.add(new PVector(r, phi));
     // Cartesian equation of a line: y = ax + b
     // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
     // => y = 0 : x = r / cos(phi)
     // => x = 0 : y = r / sin(phi)
     // compute the intersection of this line with the 4 borders of
     // the image
     //int x0 = 0;
     //int y0 = (int) (r / sin(phi));
     //int x1 = (int) (r / cos(phi));
     //int y1 = 0;
     //int x2 = original.width;
     //int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
     //int y3 = original.width;
     //int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
     //// Finally, plot the lines
     //stroke(204,102,0);
     //if (y0 > 0) {
     //  if (x1 > 0)
     //    line(x0, y0, x1, y1);
     //  else if (y2 > 0)
     //    line(x0, y0, x2, y2);
     //  else
     //    line(x0, y0, x3, y3);
     //}
     //else {
     //  if (x1 > 0) {
     //    if (y2 > 0)
     //      line(x1, y1, x2, y2);
     //    else
     //      line(x1, y1, x3, y3);
     //  }
     //  else
     //    line(x2, y2, x3, y3);
     //}
  }
   return lines;
  
}

ArrayList<PVector> drawIntersectionsAndQuads(ArrayList<PVector> lines) {
      ArrayList<PVector> intersections = new ArrayList<PVector>();

  graph.build(lines, original.width, original.height);
  List<int[]> quads = graph.findCycles();
  for(int[] quad : quads) {
    PVector l1 = lines.get(quad[0]);
    PVector l2 = lines.get(quad[1]);
    PVector l3 = lines.get(quad[2]);
    PVector l4 = lines.get(quad[3]);
    PVector c12 = graph.intersection(l1, l2, original.width, original.height);
    PVector c23 = graph.intersection(l2, l3, original.width, original.height);
    PVector c34 = graph.intersection(l3, l4, original.width, original.height);
    PVector c41 = graph.intersection(l4, l1, original.width, original.height);
    
    if(graph.isConvex(c12, c23, c34, c41) && graph.validArea(c12, c23, c34, c41, width * height, 8000)
        && graph.nonFlatQuad(c12, c23, c34, c41)) {
          stroke(204, 102, 0);
          fill(color(255, 255, 255, 0));
          quad(c12.x,c12.y,c23.x,c23.y,c34.x,c34.y,c41.x,c41.y);
          fill(255, 128, 0);
          ellipse(c12.x, c12.y, 10, 10);
          ellipse(c23.x, c23.y, 10, 10);
          ellipse(c34.x, c34.y, 10, 10);
          ellipse(c41.x, c41.y, 10, 10);
          intersections.add(new PVector(c12.x, c12.y,1));
          intersections.add(new PVector(c23.x, c23.y,1));
          intersections.add(new PVector(c34.x, c34.y,1));
          intersections.add(new PVector(c41.x, c41.y,1));
    }
  }
  
  ////ArrayList<PVector> intersections = new ArrayList<PVector>();
  //for (int i = 0; i < lines.size() - 1; i++) {
  //  PVector line1 = lines.get(i);
  //    for (int j = i + 1; j < lines.size(); j++) {
  //      PVector line2 = lines.get(j);
  //      // compute the intersection and add it to 'intersections'
  //      float d = cos(line2.y) * sin(line1.y) - cos(line1.y) * sin(line2.y);
  //      int x = (int) ((line2.x * sin(line1.y) - line1.x * sin(line2.y)) / (d));
  //      int y = (int) ((-line2.x * cos(line1.y) + line1.x * cos(line2.y)) / (d));
  //      // draw the intersection
  //      fill(255, 128, 0);
  //      ellipse(x, y, 10, 10);
  //      //intersections.add(new PVector(x, y));
  //    }
  //}
  return intersections;
}