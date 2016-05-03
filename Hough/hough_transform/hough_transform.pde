
import processing.video.*;
import java.util.Collections;

HScrollbar thresholdBar1;
HScrollbar thresholdBar2;
float threshold = 128;
PImage res;
PImage res2;
PImage hough;


Capture cam;
PImage img;

void settings() {
  size(800, 600); //640 480
}

void setup() {
  img = loadImage("board1.jpg");
  thresholdBar1 = new HScrollbar(0, 580, 800, 20);
  thresholdBar2 = new HScrollbar(0, 555, 800, 20);
  //String[] cameras = Capture.list();
  //if(cameras.length == 0) {
  //  println("There are no cameras available for capture.");
  //  exit();
  //  } else {
  //      println("Available cameras:");
  //    for (int i = 0; i < cameras.length; i++) {
  //        println(cameras[i]);
  //    }
  //    cam = new Capture(this, 640, 480);
  //    cam.start();
  //  }
  //hough = hough(res2);
  
  //for(int x = 0; x < img.width; x++) {
  //  for(int y = 0; y < img.height; y++) {
  //    if(brightness(img.pixels[x + y * img.width]) > 200) {
  //      img.pixels[x + y * img.width] = color(64, 234, 105);
  //    }
  //    if(brightness(img.pixels[x + y * img.width]) < 55) {
  //      img.pixels[x + y * img.width] = color(8, 52, 19);
  //    }
  //  }
  //}
}

void draw() {
  background(color(0, 0, 0));
  //img.loadPixels();
  
  //if(cam.available() == true) {
  //  cam.read();
  //}
  //img = cam.get();
  image(img, 0, 0);
  res = createImage(img.width, img.height, ALPHA);
  for(int i = 0; i < img.width * img.height; i++) {
    if(hue(img.pixels[i]) >= 96 && hue(img.pixels[i]) <= 
      140 && brightness(img.pixels[i]) >= 19 && brightness(img.pixels[i]) <= 
      171 && saturation(img.pixels[i]) >= 58 && saturation(img.pixels[i]) <= 
      256) {
        res.pixels[i] = img.pixels[i];
     } else {
        res.pixels[i] = color(0, 0, 0);
     }
  }
  res2 = sobel(res);
  res2.updatePixels();
  hough(res2, 20);
  //image(res2, 0, 0);
  //thresholdBar1.display();
  //thresholdBar1.update();
  //thresholdBar2.display();
  //thresholdBar2.update();
  
  //print(thresholdBar1.getPos()+" "+thresholdBar2.getPos());
  
}

PImage sobel(PImage img) {
  
  float[][] hKernel = { { 0,  1, 0 },
                        { 0,  0, 0 },
                        { 0, -1, 0 } };
                        
  float[][] vKernel = { { 0,  0,  0  },
                        { 1,  0, -1 },
                        { 0,  0,  0  } };
                        
  PImage result = createImage(img.width, img.height, ALPHA);
  
  for (int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(0);
  }
  
  result.loadPixels();
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

PImage convolute(PImage img) {
  
 float[][] kernel = { { 9, 12, 9 },
                      { 12, 15, 12 },
                      { 9, 12, 9 }};
                       
 float weight = 4 * 9 + 4 * 12 + 15;
 int sum = 0;
 
 int N = 3; 
 
 PImage result = createImage(img.width, img.height, ALPHA);
 result.loadPixels();
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
     result.pixels[y * img.width + x] = color(sum / weight);
   }
 }
 result.updatePixels();
 return result;
  
  
}

ArrayList<PVector> hough(PImage edgeImg, int nLines) {
  
  edgeImg.loadPixels();
  float discretizationStepsPhi = .06f;
  float discretizationStepsR = 2.5f;
  
  // dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi);
  int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);
  
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
          float phi = i * discretizationStepsPhi;
          double r = x * cos(phi) + y * sin(phi);
          r /= discretizationStepsR;
          r += (rDim - 1) / 2;
          accumulator[(int)((i + 1) * (rDim + 2) + (r + 1))] += 1;
        }
        // ...determine here all the lines (r, phi) passing through
        // pixel (x,y), convert (r,phi) to coordinates in the
        // accumulator, and increment accordingly the accumulator.
        // Be careful: r may be negative, so you may want to center onto
        // the accumulator with something like: r += (rDim - 1) / 2
      }
    }
  }
  int minVotes = 200;
  ArrayList<Integer> bestCandidates = new ArrayList();
  
  for(int idx = 0; idx < accumulator.length; idx++) {
    if(accumulator[idx] > minVotes && !bestCandidates.contains(idx)) {
      bestCandidates.add(idx);
    }
  }
  
  // size of the region we search for a local maximum
  int neighbourhood = 10;
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
  
  Collections.sort(bestCandidates, new HoughComparator(accumulator));
  int i = 0;
  
  
  
  
  //while(i < nLines && i < bestCandidates.size()) {
  //    int idx = bestCandidates.get(i);
  //    i++;
  //    int accPhi = (int) (idx / (rDim + 2)) - 1;
  //    int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
  //    float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
  //    float phi = accPhi * discretizationStepsPhi;
  //    // Cartesian equation of a line: y = ax + b
  //    // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
  //    // => y = 0 : x = r / cos(phi)
  //    // => x = 0 : y = r / sin(phi)
  //    // compute the intersection of this line with the 4 borders of
  //    // the image
  //    int x0 = 0;
  //    int y0 = (int) (r / sin(phi));
  //    int x1 = (int) (r / cos(phi));
  //    int y1 = 0;
  //    int x2 = edgeImg.width;
  //    int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
  //    int y3 = edgeImg.width;
  //    int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
  //    // Finally, plot the lines
  //    stroke(204,102,0);
  //    if (y0 > 0) {
  //      if (x1 > 0)
  //        line(x0, y0, x1, y1);
  //      else if (y2 > 0)
  //        line(x0, y0, x2, y2);
  //      else
  //        line(x0, y0, x3, y3);
  //    }
  //    else {
  //      if (x1 > 0) {
  //        if (y2 > 0)
  //          line(x1, y1, x2, y2);
  //        else
  //          line(x1, y1, x3, y3);
  //      }
  //      else
  //        line(x2, y2, x3, y3);
  //    }
  //}
  
  
  
  // PImage houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
  //for (int i = 0; i < accumulator.length; i++) {
  //  houghImg.pixels[i] = color(min(255, accumulator[i]));
  //}
  //// You may want to resize the accumulator to make it easier to see:
  //houghImg.resize(400, 400);

  
}